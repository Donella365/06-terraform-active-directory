data "azurerm_client_config" "current" {}

# Generates a random 8-character suffix so the vault name is unique
# across all of Azure, not just your subscription.
resource "random_id" "kv_suffix" {
  byte_length = 4
}

resource "azurerm_key_vault" "lab_kv" {
  name                       = "kv-ad-${random_id.kv_suffix.hex}"
  location                   = azurerm_resource_group.main.location
  resource_group_name        = azurerm_resource_group.main.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  enable_rbac_authorization  = true   # required, or every secret read/write gets a 403 error
  soft_delete_retention_days = 7
  purge_protection_enabled   = false
  tags                       = var.tags
}

# Gives your logged-in Azure identity permission to read/write secrets
resource "azurerm_role_assignment" "kv_deployer_access" {
  scope                = azurerm_key_vault.lab_kv.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_key_vault_secret" "admin_password" {
  name         = "vm-admin-password"
  value        = random_password.admin.result
  key_vault_id = azurerm_key_vault.lab_kv.id
  depends_on   = [azurerm_role_assignment.kv_deployer_access]
}

resource "azurerm_key_vault_secret" "dsrm_password" {
  name         = "dsrm-password"
  value        = random_password.dsrm.result
  key_vault_id = azurerm_key_vault.lab_kv.id
  depends_on   = [azurerm_role_assignment.kv_deployer_access]
}

# Terraform generates strong random passwords for you — no need to
# invent one, and it never gets typed into any file.
resource "random_password" "admin" {
  length  = 20
  special = true
}

resource "random_password" "dsrm" {
  length  = 20
  special = true
}