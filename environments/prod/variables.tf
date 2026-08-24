variable "resource_group_name" {
  description = "Name of the prod resource group"
  type        = string
  default     = "rg-foundation-prod"
}

variable "location" {
  description = "Azure region for prod resources"
  type        = string
  default     = "eastus"
}

variable "vnet_name" {
  description = "Name of the prod virtual network"
  type        = string
  default     = "vnet-foundation-prod"
}

variable "vnet_address_space" {
  description = "Address space for the prod virtual network"
  type        = list(string)
  default     = ["10.20.0.0/16"]
}

variable "subnets" {
  description = "Map of subnets to create in the prod virtual network"
  type = map(object({
    address_prefixes = list(string)
  }))
  default = {
    "snet-app" = {
      address_prefixes = ["10.20.1.0/24"]
    }
  }
}

variable "key_vault_name" {
  description = "Name of the prod Key Vault (must be globally unique)"
  type        = string
  default     = "kv-foundation-prod"
}

variable "tags" {
  description = "Tags applied to all prod resources"
  type        = map(string)
  default = {
    environment = "prod"
    project     = "azure-terraform-cicd-foundation"
  }
}
