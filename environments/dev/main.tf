terraform {
  required_version = ">= 1.8.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.90"
    }
  }

  backend "azurerm" {
    # Configure via -backend-config or environment variables in CI/CD.
    # resource_group_name  = "tfstate-rg"
    # storage_account_name = "tfstatestorage"
    # container_name       = "tfstate"
    # key                  = "dev.terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

module "resource_group" {
  source = "../../modules/resource_group"

  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

module "vnet" {
  source = "../../modules/vnet"

  name                = var.vnet_name
  address_space       = var.vnet_address_space
  location            = var.location
  resource_group_name = module.resource_group.name
  subnets             = var.subnets
  tags                = var.tags
}

module "key_vault" {
  source = "../../modules/key_vault"

  name                = var.key_vault_name
  location            = var.location
  resource_group_name = module.resource_group.name
  tags                = var.tags
}
