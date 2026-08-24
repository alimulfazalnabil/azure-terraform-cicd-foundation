resource_group_name = "rg-enterprise-dev-01"
location            = "eastus"

vnet_name     = "vnet-enterprise-dev-01"
address_space = ["10.10.0.0/16"]

subnets = {
  "snet-web" = {
    address_prefixes = ["10.10.1.0/24"]
  }
  "snet-db" = {
    address_prefixes = ["10.10.2.0/24"]
  }
}

key_vault_name = "kv-dev-enterprise-01"

tags = {
  Environment = "Development"
  ManagedBy   = "Terraform"
  Project     = "Azure-Solutions-Portfolio"
}
