variable "key_vault_name" {
  description = "Name of the Key Vault (must be globally unique)"
  type        = string
}

variable "location" {
  description = "Azure region for the Key Vault"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group in which to create the Key Vault"
  type        = string
}

variable "sku_name" {
  description = "SKU for the Key Vault (standard or premium)"
  type        = string
  default     = "standard"
}

variable "tags" {
  description = "Tags to apply to the Key Vault"
  type        = map(string)
  default     = {}
}
