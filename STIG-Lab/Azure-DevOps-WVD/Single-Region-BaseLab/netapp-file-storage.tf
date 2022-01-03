#Create Azure NetApp Files Account and Capacity Pool
resource "azurerm_netapp_account" "region1-anf" {
  name                = "region1-anf"
  resource_group_name = azurerm_resource_group.rg1.name
  location            = var.loc1
}
resource "azurerm_netapp_pool" "region1-anf-pool1" {
  name                = "pool1"
  account_name        = azurerm_netapp_account.region1-anf.name
  location            = var.loc1
  resource_group_name = azurerm_resource_group.rg1.name
  service_level       = "Standard"
  size_in_tb          = 4
}