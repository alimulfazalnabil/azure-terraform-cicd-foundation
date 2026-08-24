# ---------------------------------------------------------------
# Dev environment – sample variable values
# These are non-sensitive illustrative values.
# Sensitive values (client_id, tenant_id, etc.) are passed via
# environment variables or GitHub Actions secrets.
# ---------------------------------------------------------------

project        = "myapp"
environment    = "dev"
location       = "eastus"
location_short = "eus"

vnet_address_space = ["10.10.0.0/16"]

subnets = [
  {
    name             = "web"
    address_prefixes = ["10.10.1.0/24"]
    nsg_rules = [
      {
        name                       = "allow-https-inbound"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "Internet"
        destination_address_prefix = "*"
      }
    ]
  },
  {
    name             = "db"
    address_prefixes = ["10.10.2.0/24"]
    nsg_rules = [
      {
        name                       = "allow-sql-from-web"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "1433"
        source_address_prefix      = "10.10.1.0/24"
        destination_address_prefix = "*"
      },
      {
        name                       = "deny-internet-inbound"
        priority                   = 200
        direction                  = "Inbound"
        access                     = "Deny"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = "Internet"
        destination_address_prefix = "*"
      }
    ]
  }
]

key_vault_sku              = "standard"
key_vault_purge_protection = false
key_vault_soft_delete_days = 30

tags = {
  owner      = "platform-team"
  cost_center = "engineering"
}
