variable "resource_group_name" {
  description = "Name of the dev resource group"
  type        = string
  default     = "rg-foundation-dev"
}

variable "location" {
  description = "Azure region for dev resources"
  type        = string
  default     = "eastus"
}

variable "vnet_name" {
  description = "Name of the dev virtual network"
  type        = string
  default     = "vnet-foundation-dev"
}

variable "vnet_address_space" {
  description = "Address space for the dev virtual network"
  type        = list(string)
  default     = ["10.10.0.0/16"]
}

variable "subnets" {
  description = "Map of subnets to create in the dev virtual network"
  type = map(object({
    address_prefixes = list(string)
  }))
  default = {
    "snet-app" = {
      address_prefixes = ["10.10.1.0/24"]
    }
  }
}

variable "key_vault_name" {
  description = "Name of the dev Key Vault (must be globally unique)"
  type        = string
  default     = "kv-foundation-dev"
}

variable "tags" {
  description = "Tags applied to all dev resources"
  type        = map(string)
  default = {
    environment = "dev"
    project     = "azure-terraform-cicd-foundation"
  }
}
