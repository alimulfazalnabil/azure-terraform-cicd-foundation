# ---------------------------------------------------------------
# Module: key_vault
# Provisions an Azure Key Vault with RBAC, soft-delete, and
# purge protection enabled.
# ---------------------------------------------------------------

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0, < 5.0"
    }
  }
}

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "this" {
  name                        = var.key_vault_name
  location                    = var.location
  resource_group_name         = var.resource_group_name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = var.sku_name

  # Use Azure RBAC instead of legacy access policies
  enable_rbac_authorization   = true

  # Soft-delete: keys/secrets are retained for the retention period after deletion
  soft_delete_retention_days  = var.soft_delete_retention_days

  # Purge protection: prevents immediate permanent deletion
  purge_protection_enabled    = var.purge_protection_enabled

  # Optional: restrict access to specific networks
  dynamic "network_acls" {
    for_each = var.network_acls != null ? [var.network_acls] : []
    content {
      default_action             = network_acls.value.default_action
      bypass                     = network_acls.value.bypass
      ip_rules                   = lookup(network_acls.value, "ip_rules", [])
      virtual_network_subnet_ids = lookup(network_acls.value, "virtual_network_subnet_ids", [])
    }
  }

  tags = var.tags
}

# Grant the deploying identity Key Vault Administrator role so it can
# manage secrets/keys after provisioning (only when rbac_role_assignments
# variable contains entries).
resource "azurerm_role_assignment" "kv_rbac" {
  for_each = { for ra in var.rbac_role_assignments : "${ra.principal_id}/${ra.role_definition_name}" => ra }

  scope                = azurerm_key_vault.this.id
  role_definition_name = each.value.role_definition_name
  principal_id         = each.value.principal_id
}
