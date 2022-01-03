#VNET Peering
resource "azurerm_virtual_network_peering" "peer1" {
  name                      = "region1-vnet1-to-region1-vnet2"
  resource_group_name       = azurerm_resource_group.rg1.name
  virtual_network_name      = azurerm_virtual_network.region1-vnet1-hub1.name
  remote_virtual_network_id = azurerm_virtual_network.region1-vnet2-spoke1.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}
resource "azurerm_virtual_network_peering" "peer2" {
  name                      = "region1-vnet2-to-region1-vnet1"
  resource_group_name       = azurerm_resource_group.rg1.name
  virtual_network_name      = azurerm_virtual_network.region1-vnet2-spoke1.name
  remote_virtual_network_id = azurerm_virtual_network.region1-vnet1-hub1.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}