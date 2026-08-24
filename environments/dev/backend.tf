# ---------------------------------------------------------------
# Dev environment – Terraform remote state backend
# Uses Azure Blob Storage for state locking.
# Replace the placeholder values with your actual storage account
# details, or supply them via the CI/CD pipeline's -backend-config.
# ---------------------------------------------------------------

terraform {
  backend "azurerm" {
    resource_group_name  = "rg-tfstate-shared"      # Override via -backend-config
    storage_account_name = "sttfstatedev001"         # Override via -backend-config
    container_name       = "tfstate"                 # Override via -backend-config
    key                  = "dev/terraform.tfstate"
    use_oidc             = true                      # Passwordless auth via OIDC
  }
}
