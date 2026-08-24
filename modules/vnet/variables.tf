variable "vnet_name" {
  description = "Name of the virtual network"
  type        = string
}

variable "address_space" {
  description = "Address space for the virtual network"
  type        = list(string)
}

variable "location" {
  description = "Azure region for the virtual network"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group in which to create the virtual network"
  type        = string
}

variable "subnets" {
  description = "Map of subnets to create, keyed by subnet name"
  type = map(object({
    address_prefixes = list(string)
  }))
  default = {}
}

variable "tags" {
  description = "Tags to apply to the virtual network"
  type        = map(string)
  default     = {}
}
