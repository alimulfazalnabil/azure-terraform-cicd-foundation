variable "vnet_name" {
  type        = string
  description = "The name of the Virtual Network."
}

variable "location" {
  type        = string
  description = "The Azure region for the Virtual Network."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the Resource Group in which to create the VNet."
}

variable "address_space" {
  type        = list(string)
  description = "The address space (CIDR blocks) for the Virtual Network."
}

variable "subnets" {
  description = "List of subnet configurations."
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

variable "tags" {
  type        = map(string)
  description = "A map of tags to apply to all resources."
  default     = {}
}
