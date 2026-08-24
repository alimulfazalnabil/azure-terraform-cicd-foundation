# Azure Terraform & GitHub Actions CI/CD Infrastructure Platform

An enterprise-grade, modular Infrastructure as Code (IaC) deployment framework built for Azure. This project automates multi-tier cloud resource provisioning using Terraform workspaces and secure OIDC-authenticated GitHub Actions pipelines.

## 🏗️ Architecture & Workflow

Developer (Git Push) -> GitHub Actions CI/CD -> OIDC Azure Auth -> Terraform Plan/Apply -> Secure Azure Landing Zone

## 🚀 Features

- **Modular Design:** Reusable Terraform components for Virtual Networks, Resource Groups, and Key Vaults.
- **Secure Authentication:** Passwordless OpenID Connect (OIDC) integration between GitHub Actions and Azure.
- **Environment Isolation:** Separated configurations for `dev` and `prod` environments.
- **Automated Validation:** CI checks (`terraform validate` and `plan`) enforced on every pull request.

## 🛠️ Tech Stack

- **Cloud Provider:** Microsoft Azure
- **Infrastructure as Code:** Terraform
- **CI/CD Orchestration:** GitHub Actions
- **Security:** Azure Key Vault, OIDC federated credentials

## 📁 Repository Structure

```
azure-terraform-cicd-foundation/
├── .github/
│   └── workflows/
│       └── terraform-pipeline.yml   # GitHub Actions CI/CD workflow
├── modules/
│   ├── resource_group/              # Reusable RG module
│   ├── vnet/                        # VNet and Subnets module
│   └── key_vault/                   # Key Vault & Secrets module
├── environments/
│   ├── dev/
│   │   ├── backend.tf
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── terraform.tfvars
│   └── prod/                        # Production environment configuration
│       ├── backend.tf
└── README.md
```

## ⚙️ Getting Started

### Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/downloads) >= 1.8.0
- An Azure subscription
- A GitHub OIDC federated credential configured for Azure (`AZURE_CLIENT_ID`, `AZURE_TENANT_ID`, `AZURE_SUBSCRIPTION_ID` repository secrets)
- Azure Storage Accounts and containers matching each environment's `backend.tf` for remote state

### Local Usage

```bash
cd environments/dev
terraform init
terraform plan
terraform apply
```

### CI/CD Pipeline

The [terraform-pipeline.yml](.github/workflows/terraform-pipeline.yml) workflow:

1. Runs formatting, initialization, validation, and `terraform plan` for both `dev` and `prod` on every pull request targeting `main`.
2. Runs `terraform apply` for both environments when changes are pushed to `main`.
3. Authenticates to Azure using passwordless OIDC — no long-lived credentials are stored in GitHub.

## 🔒 Security Notes

- No client secrets are stored in the repository or CI/CD pipeline; authentication uses OIDC federated identity.
- The Key Vault module uses RBAC authorization with seven-day soft-delete retention and purge protection disabled, matching the sample configuration.
- Terraform state should always be stored in a remote, encrypted backend (e.g., Azure Storage Account with versioning).

## 📄 License

This project is provided as-is for infrastructure automation reference and portfolio purposes.
