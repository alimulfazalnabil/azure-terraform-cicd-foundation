output "vnet_id" {
  description = "The resource ID of the Virtual Network."
  value       = azurerm_virtual_network.this.id
}

output "vnet_name" {
  description = "The name of the Virtual Network."
  value       = azurerm_virtual_network.this.name
}

output "subnet_ids" {
  description = "A map of subnet name to subnet ID."
  value       = { for k, v in azurerm_subnet.this : k => v.id }
}

output "nsg_ids" {
  description = "A map of subnet name to NSG ID."
  value       = { for k, v in azurerm_network_security_group.this : k => v.id }
}
