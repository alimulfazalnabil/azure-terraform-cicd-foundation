output "id" {
  description = "The resource group ID"
  value       = azurerm_resource_group.this.id
}

output "name" {
  description = "The resource group name"
  value       = azurerm_resource_group.this.name
}

output "location" {
  description = "The resource group location"
  value       = azurerm_resource_group.this.location
}
