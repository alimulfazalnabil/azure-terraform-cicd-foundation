output "resource_group_name" {
  description = "The name of the dev resource group"
  value       = module.rg.name
}

output "vnet_id" {
  description = "The ID of the dev virtual network"
  value       = module.vnet.vnet_id
}

output "subnet_ids" {
  description = "Map of dev subnet names to IDs"
  value       = module.vnet.subnet_ids
}

output "key_vault_uri" {
  description = "The URI of the dev Key Vault"
  value       = module.key_vault.vault_uri
}
