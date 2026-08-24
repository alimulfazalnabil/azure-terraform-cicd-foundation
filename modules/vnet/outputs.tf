output "vnet_id" {
  description = "The virtual network ID"
  value       = azurerm_virtual_network.this.id
}

output "vnet_name" {
  description = "The virtual network name"
  value       = azurerm_virtual_network.this.name
}

output "subnet_ids" {
  description = "Map of subnet names to subnet IDs"
  value       = { for k, s in azurerm_subnet.this : k => s.id }
}
