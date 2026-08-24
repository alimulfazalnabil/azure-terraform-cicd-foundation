resource_group_name = "rg-foundation-dev"
location            = "eastus"

vnet_name           = "vnet-foundation-dev"
vnet_address_space  = ["10.10.0.0/16"]

subnets = {
  "snet-app" = {
    address_prefixes = ["10.10.1.0/24"]
  }
}

key_vault_name = "kv-foundation-dev"

tags = {
  environment = "dev"
  project     = "azure-terraform-cicd-foundation"
}
