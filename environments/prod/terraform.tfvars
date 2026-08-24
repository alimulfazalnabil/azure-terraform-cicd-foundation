# ---------------------------------------------------------------
# Prod environment – sample variable values
# Production uses larger address spaces, premium SKUs, and
# stricter security controls.
# ---------------------------------------------------------------

project        = "myapp"
environment    = "prod"
location       = "eastus"
location_short = "eus"

vnet_address_space = ["10.20.0.0/16"]

subnets = [
  {
    name             = "web"
    address_prefixes = ["10.20.1.0/24"]
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
    name             = "app"
    address_prefixes = ["10.20.2.0/24"]
    nsg_rules = [
      {
        name                       = "allow-http-from-web"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "8080"
        source_address_prefix      = "10.20.1.0/24"
        destination_address_prefix = "*"
      }
    ]
  },
  {
    name             = "db"
    address_prefixes = ["10.20.3.0/24"]
    nsg_rules = [
      {
        name                       = "allow-sql-from-app"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "1433"
        source_address_prefix      = "10.20.2.0/24"
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

key_vault_sku              = "premium"
key_vault_purge_protection = true
key_vault_soft_delete_days = 90

tags = {
  owner       = "platform-team"
  cost_center = "engineering"
  criticality = "high"
}
