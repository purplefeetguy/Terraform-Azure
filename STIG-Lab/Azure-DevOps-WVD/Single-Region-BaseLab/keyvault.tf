#Keyvault Creation
#data "azurerm_client_config" "current" {}
resource "azurerm_key_vault" "kv1" {
  depends_on = [ azurerm_resource_group.rg2 ]
  name                        = var.keyvault
  location                    = var.loc1
  resource_group_name         = var.azure-rg-2
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = "__portaladminaccount__"

    key_permissions = [
      "get",
    ]

    secret_permissions = [
      "get", "backup", "delete", "list", "purge", "recover", "restore", "set",
    ]

    storage_permissions = [
      "get",
    ]
  }
    access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "get",
    ]

    secret_permissions = [
      "get", "backup", "delete", "list", "purge", "recover", "restore", "set",
    ]

    storage_permissions = [
      "get",
    ]
  }
   tags     = {
       Environment  = var.environment_tag
   }
}
#Create KeyVault VM password
resource "random_password" "vmpassword" {
  length = 20
  special = true
}
#Create KeyVault user password
resource "random_password" "userpassword" {
  length = 20
  special = true
}
#Create Key Vault VM Secret
resource "azurerm_key_vault_secret" "vmpassword" {
  name         = "vmpassword"
  value        = random_password.vmpassword.result
  key_vault_id = azurerm_key_vault.kv1.id
}
#Create Key Vault User Secret
resource "azurerm_key_vault_secret" "userpassword" {
  name         = "userpassword"
  value        = random_password.userpassword.result
  key_vault_id = azurerm_key_vault.kv1.id
}