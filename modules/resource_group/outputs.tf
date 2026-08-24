output "name" {
  description = "The name of the Resource Group."
  value       = azurerm_resource_group.this.name
}

output "id" {
  description = "The resource ID of the Resource Group."
  value       = azurerm_resource_group.this.id
}

output "location" {
  description = "The Azure region of the Resource Group."
  value       = azurerm_resource_group.this.location
}
