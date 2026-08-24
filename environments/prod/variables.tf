variable "project" {
  type        = string
  description = "Short project/application name used in resource naming."
}

variable "environment" {
  type        = string
  description = "Deployment environment identifier (e.g., dev, staging, prod)."
}

variable "location" {
  type        = string
  description = "Primary Azure region for all resources."
}

variable "location_short" {
  type        = string
  description = "Short location code used in resource names (e.g., 'eus' for East US)."
}

variable "vnet_address_space" {
  type        = list(string)
  description = "Address space for the Virtual Network."
}

variable "subnets" {
  description = "Subnet configurations for the Virtual Network."
  type = list(object({
    name             = string
    address_prefixes = list(string)
    nsg_rules = optional(list(object({
      name                       = string
      priority                   = number
      direction                  = string
      access                     = string
      protocol                   = string
      source_port_range          = string
      destination_port_range     = string
      source_address_prefix      = string
      destination_address_prefix = string
    })), [])
    delegation = optional(object({
      name                        = string
      service_delegation_name     = string
      service_delegation_actions  = list(string)
    }))
  }))
  default = []
}

variable "key_vault_sku" {
  type        = string
  description = "Key Vault SKU tier ('standard' or 'premium')."
  default     = "premium"
}

variable "key_vault_purge_protection" {
  type        = bool
  description = "Enable purge protection on the Key Vault."
  default     = true
}

variable "key_vault_soft_delete_days" {
  type        = number
  description = "Soft-delete retention period in days (7–90)."
  default     = 90
}

variable "key_vault_rbac_assignments" {
  description = "RBAC role assignments for the Key Vault."
  type = list(object({
    principal_id         = string
    role_definition_name = string
  }))
  default = []
}

variable "tags" {
  type        = map(string)
  description = "Additional tags to merge with common tags."
  default     = {}
}
