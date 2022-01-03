#Create KeyVault ID
resource "random_id" "kvname" {
  byte_length = 5
  prefix      = "keyvault"
}
#Keyvault Creation
#data "azurerm_client_config" "current" {}
resource "azurerm_key_vault" "kv1" {
  depends_on                  = [azurerm_resource_group.rg2]
  name                        = random_id.kvname.hex
  location                    = var.loc1
  resource_group_name         = var.azure-rg-2
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

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
  tags = {
    Environment = var.environment_tag
    Function    = "stiglabv1-security"
    CostCenter  = "MBoudro"
  }
}
#Create KeyVault VM password - Windows
resource "random_password" "vmpassword" {
  length  = 20
  special = true
}
#Create Key Vault Secret - Windows
resource "azurerm_key_vault_secret" "vmpassword" {
  name         = "vmpassword"
  value        = random_password.vmpassword.result
  key_vault_id = azurerm_key_vault.kv1.id
  depends_on   = [azurerm_key_vault.kv1]
}
#Create KeyVault VM password - Ansible VM
resource "random_password" "anpassword" {
  length  = 20
  special = true
}
#Create Key Vault Secret - Ansible VM
resource "azurerm_key_vault_secret" "anpassword" {
  name         = "anpassword"
  value        = random_password.anpassword.result
  key_vault_id = azurerm_key_vault.kv1.id
  depends_on   = [azurerm_key_vault.kv1]
}
