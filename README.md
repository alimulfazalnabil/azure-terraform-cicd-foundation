# Azure Terraform CI/CD Foundation

An **enterprise-grade Infrastructure as Code (IaC)** framework that deploys Azure resources using **Terraform** and **GitHub Actions** with **passwordless OIDC authentication**.

---

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────────┐
│  GitHub Repository                                              │
│                                                                 │
│  ┌──────────────────┐       push / PR                          │
│  │  Developer       │──────────────────────────────────────┐   │
│  └──────────────────┘                                       │   │
│                                                             ▼   │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │  GitHub Actions – terraform-pipeline.yml                   │ │
│  │                                                            │ │
│  │  PR:   Init → Validate → Plan → Post comment on PR        │ │
│  │  Main: Init → Validate → Plan → Apply                     │ │
│  └───────────────────────────┬────────────────────────────────┘ │
└──────────────────────────────┼──────────────────────────────────┘
                               │ OIDC Token (passwordless)
                               ▼
┌─────────────────────────────────────────────────────────────────┐
│  Microsoft Azure                                                │
│                                                                 │
│  ┌──────────────────────┐   ┌──────────────────────────────┐   │
│  │  Azure AD / Entra ID │   │  Storage Account (tfstate)   │   │
│  │  Federated Identity  │   │  Blob – state locking        │   │
│  └──────────────────────┘   └──────────────────────────────┘   │
│                                                                 │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │  Provisioned Resources (per environment)                  │  │
│  │  • Resource Group  • Virtual Network + NSGs  • Key Vault  │  │
│  └───────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
```

---

## Repository Structure

```
azure-terraform-cicd-foundation/
│
├── .github/
│   └── workflows/
│       └── terraform-pipeline.yml   # CI/CD pipeline definition
│
├── modules/
│   ├── resource_group/              # Azure Resource Group module
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── vnet/                        # Virtual Network + NSG module
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── key_vault/                   # Key Vault module (RBAC-only)
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
│
├── environments/
│   ├── dev/                         # Development environment root
│   │   ├── backend.tf
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── terraform.tfvars
│   └── prod/                        # Production environment root
│       ├── backend.tf
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
│       └── terraform.tfvars
│
└── README.md
```

---

## Prerequisites

### 1. Azure Service Principal with Federated Credentials (OIDC)

Create a service principal and configure it for GitHub Actions OIDC so that **no client secrets are stored**:

```bash
# Create the application registration
az ad app create --display-name "sp-github-terraform-cicd"

# Note the appId output
APP_ID="<appId from above>"

# Create the service principal
az ad sp create --id "$APP_ID"

# Get the Object ID of the SP
SP_OBJECT_ID=$(az ad sp show --id "$APP_ID" --query id -o tsv)

# Assign Contributor role on the subscription
SUBSCRIPTION_ID=$(az account show --query id -o tsv)
az role assignment create \
  --assignee "$SP_OBJECT_ID" \
  --role "Contributor" \
  --scope "/subscriptions/$SUBSCRIPTION_ID"

# Add a federated credential for the main branch (for Apply)
az ad app federated-credential create \
  --id "$APP_ID" \
  --parameters '{
    "name": "github-main",
    "issuer": "https://token.actions.githubusercontent.com",
    "subject": "repo:<YOUR_GITHUB_ORG>/<YOUR_REPO>:ref:refs/heads/main",
    "audiences": ["api://AzureADTokenExchange"]
  }'

# Add a federated credential for pull requests (for Plan)
az ad app federated-credential create \
  --id "$APP_ID" \
  --parameters '{
    "name": "github-pr",
    "issuer": "https://token.actions.githubusercontent.com",
    "subject": "repo:<YOUR_GITHUB_ORG>/<YOUR_REPO>:pull_request",
    "audiences": ["api://AzureADTokenExchange"]
  }'
```

### 2. Terraform State Backend (Azure Storage)

```bash
RESOURCE_GROUP="rg-tfstate-shared"
STORAGE_ACCOUNT="sttfstatedev001"   # Must be globally unique
CONTAINER="tfstate"
LOCATION="eastus"

az group create --name "$RESOURCE_GROUP" --location "$LOCATION"
az storage account create \
  --name "$STORAGE_ACCOUNT" \
  --resource-group "$RESOURCE_GROUP" \
  --sku Standard_LRS \
  --kind StorageV2 \
  --min-tls-version TLS1_2 \
  --allow-blob-public-access false
az storage container create \
  --name "$CONTAINER" \
  --account-name "$STORAGE_ACCOUNT"
```

Grant the service principal **Storage Blob Data Contributor** on the storage account:

```bash
STORAGE_ID=$(az storage account show \
  --name "$STORAGE_ACCOUNT" \
  --resource-group "$RESOURCE_GROUP" \
  --query id -o tsv)

az role assignment create \
  --assignee "$SP_OBJECT_ID" \
  --role "Storage Blob Data Contributor" \
  --scope "$STORAGE_ID"
```

### 3. GitHub Repository Secrets

Add the following secrets in **Settings → Secrets and variables → Actions**:

| Secret Name | Value |
|---|---|
| `AZURE_CLIENT_ID` | Application (client) ID of the service principal |
| `AZURE_TENANT_ID` | Directory (tenant) ID |
| `AZURE_SUBSCRIPTION_ID` | Target Azure subscription ID |
| `BACKEND_RESOURCE_GROUP` | `rg-tfstate-shared` |
| `BACKEND_STORAGE_ACCOUNT` | `sttfstatedev001` |
| `BACKEND_CONTAINER` | `tfstate` |

---

## Pipeline Workflow

| Trigger | Jobs |
|---|---|
| **Pull Request** → `main` | `terraform init` → `terraform validate` → `terraform plan` → Post plan as PR comment |
| **Push** → `main` | `terraform init` → `terraform validate` → `terraform plan` → `terraform apply` |

The pipeline targets the **`environments/dev`** directory by default. For production, duplicate the workflow job and change `WORKING_DIR` to `environments/prod`.

---

## Deployment Instructions

### Local Development

```bash
# 1. Install Terraform >= 1.5 and Azure CLI

# 2. Log in to Azure
az login

# 3. Navigate to the target environment
cd environments/dev

# 4. Initialise (using local backend for dev testing)
terraform init

# 5. Review the plan
terraform plan -var-file=terraform.tfvars

# 6. Apply
terraform apply -var-file=terraform.tfvars
```

### CI/CD (GitHub Actions)

1. Push changes to a feature branch and open a Pull Request — the pipeline automatically runs `plan` and posts the output as a PR comment.
2. After review and merge to `main`, the pipeline runs `apply` automatically.

---

## Modules

### `modules/resource_group`
Creates an Azure Resource Group with configurable name, location, and tags.

### `modules/vnet`
Creates an Azure Virtual Network with:
- Configurable address space
- Multiple subnets (e.g., `web`, `app`, `db`)
- Per-subnet Network Security Groups (NSGs) with inline rules
- NSG-to-subnet associations

### `modules/key_vault`
Provisions an Azure Key Vault with:
- **RBAC authorization** enabled (no legacy access policies)
- **Soft-delete** with configurable retention (7–90 days)
- **Purge protection** (recommended for production)
- Optional network ACLs
- Optional RBAC role assignments at vault scope

---

## Security Considerations

- **No passwords or client secrets** — authentication uses OIDC federated credentials exclusively.
- **State file** is stored in Azure Blob Storage with soft-delete and versioning; access is controlled by RBAC.
- **Key Vault** uses RBAC authorization rather than the legacy vault access policy model.
- **Purge protection** is enabled in production to prevent accidental permanent deletion.
- NSG rules follow a least-privilege, tiered model (web → app → db).

---

## License

MIT
