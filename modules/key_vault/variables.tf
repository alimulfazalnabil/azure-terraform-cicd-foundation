variable "key_vault_name" {
  type        = string
  description = "The globally unique name of the Azure Key Vault (3-24 alphanumeric characters and hyphens)."
}

variable "location" {
  type        = string
  description = "The Azure region in which to create the Key Vault."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the Resource Group in which to create the Key Vault."
}

variable "sku_name" {
  type        = string
  description = "The SKU tier for the Key Vault. Valid values: 'standard' or 'premium'."
  default     = "standard"

  validation {
    condition     = contains(["standard", "premium"], var.sku_name)
    error_message = "sku_name must be either 'standard' or 'premium'."
  }
}

variable "soft_delete_retention_days" {
  type        = number
  description = "The number of days soft-deleted objects are retained (7–90)."
  default     = 90

  validation {
    condition     = var.soft_delete_retention_days >= 7 && var.soft_delete_retention_days <= 90
    error_message = "soft_delete_retention_days must be between 7 and 90."
  }
}

variable "purge_protection_enabled" {
  type        = bool
  description = "Whether purge protection is enabled. When true, the vault and its objects cannot be permanently deleted during the retention period."
  default     = true
}

variable "network_acls" {
  description = "Optional network ACL configuration for the Key Vault."
  type = object({
    default_action             = string
    bypass                     = list(string)
    ip_rules                   = optional(list(string), [])
    virtual_network_subnet_ids = optional(list(string), [])
  })
  default = null
}

variable "rbac_role_assignments" {
  description = "List of RBAC role assignments to create on the Key Vault scope."
  type = list(object({
    principal_id         = string
    role_definition_name = string
  }))
  default = []
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to apply to the Key Vault."
  default     = {}
}
