# ---------------------------------------------------------------
# Environment: prod
# Root module for the production environment.
# ---------------------------------------------------------------

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0, < 5.0"
    }
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = false
    }
  }
}

# ---------------------------------------------------------------
# Resource Group
# ---------------------------------------------------------------
module "resource_group" {
  source = "../../modules/resource_group"

  name     = "rg-${var.project}-${var.environment}-${var.location_short}"
  location = var.location
  tags     = local.common_tags
}

# ---------------------------------------------------------------
# Virtual Network
# ---------------------------------------------------------------
module "vnet" {
  source = "../../modules/vnet"

  vnet_name           = "vnet-${var.project}-${var.environment}-${var.location_short}"
  location            = var.location
  resource_group_name = module.resource_group.name
  address_space       = var.vnet_address_space
  subnets             = var.subnets
  tags                = local.common_tags

  depends_on = [module.resource_group]
}

# ---------------------------------------------------------------
# Key Vault
# ---------------------------------------------------------------
module "key_vault" {
  source = "../../modules/key_vault"

  key_vault_name      = "kv-${var.project}-${var.environment}"
  location            = var.location
  resource_group_name = module.resource_group.name
  sku_name            = var.key_vault_sku
  purge_protection_enabled   = var.key_vault_purge_protection
  soft_delete_retention_days = var.key_vault_soft_delete_days
  rbac_role_assignments      = var.key_vault_rbac_assignments
  tags                       = local.common_tags

  depends_on = [module.resource_group]
}

# ---------------------------------------------------------------
# Local values
# ---------------------------------------------------------------
locals {
  common_tags = merge(var.tags, {
    environment = var.environment
    project     = var.project
    managed_by  = "terraform"
  })
}
