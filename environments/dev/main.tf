module "rg" {
  source = "../../modules/resource_group"

  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
}

module "vnet" {
  source = "../../modules/vnet"

  vnet_name           = var.vnet_name
  resource_group_name = module.rg.name
  location            = module.rg.location
  address_space       = var.address_space
  subnets             = var.subnets
  tags                = var.tags
}

module "key_vault" {
  source = "../../modules/key_vault"

  key_vault_name      = var.key_vault_name
  location            = var.location
  resource_group_name = module.rg.name
  tags                = var.tags
}
