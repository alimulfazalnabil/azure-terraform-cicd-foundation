output "resource_group_id" {
  description = "Resource ID of the development Resource Group."
  value       = module.resource_group.id
}

output "resource_group_name" {
  description = "Name of the development Resource Group."
  value       = module.resource_group.name
}

output "vnet_id" {
  description = "Resource ID of the Virtual Network."
  value       = module.vnet.vnet_id
}

output "vnet_name" {
  description = "Name of the Virtual Network."
  value       = module.vnet.vnet_name
}

output "subnet_ids" {
  description = "Map of subnet name to subnet resource ID."
  value       = module.vnet.subnet_ids
}

output "key_vault_id" {
  description = "Resource ID of the Key Vault."
  value       = module.key_vault.key_vault_id
}

output "key_vault_uri" {
  description = "URI of the Key Vault used to reference secrets and keys."
  value       = module.key_vault.key_vault_uri
}
