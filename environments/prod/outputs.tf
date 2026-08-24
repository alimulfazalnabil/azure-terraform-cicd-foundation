output "resource_group_name" {
  description = "The name of the prod resource group"
  value       = module.resource_group.name
}

output "vnet_id" {
  description = "The ID of the prod virtual network"
  value       = module.vnet.vnet_id
}

output "subnet_ids" {
  description = "Map of prod subnet names to IDs"
  value       = module.vnet.subnet_ids
}

output "key_vault_uri" {
  description = "The URI of the prod Key Vault"
  value       = module.key_vault.vault_uri
}
