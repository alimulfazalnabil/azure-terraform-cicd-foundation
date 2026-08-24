resource_group_name = "rg-foundation-prod"
location            = "eastus"

vnet_name           = "vnet-foundation-prod"
vnet_address_space  = ["10.20.0.0/16"]

subnets = {
  "snet-app" = {
    address_prefixes = ["10.20.1.0/24"]
  }
}

key_vault_name = "kv-foundation-prod"

tags = {
  environment = "prod"
  project     = "azure-terraform-cicd-foundation"
}
