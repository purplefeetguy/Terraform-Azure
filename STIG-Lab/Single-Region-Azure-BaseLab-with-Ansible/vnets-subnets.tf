# #VNETs and Subnets
# #Hub VNET and Subnets
# resource "azurerm_virtual_network" "region1-vnet1-hub1" {
#   name                = var.region1-vnet1-name
#   location            = var.loc1
#   resource_group_name = azurerm_resource_group.rg1.name
#   address_space       = [var.region1-vnet1-address-space]
#   dns_servers         = ["10.10.1.4", "168.63.129.16", "8.8.8.8"]
#   tags = {
#     Environment = var.environment_tag
#     Function    = "baselabv1-network"
#   }
# }
# resource "azurerm_subnet" "region1-vnet1-snet1" {
#   name                 = var.region1-vnet1-snet1-name
#   resource_group_name  = azurerm_resource_group.rg1.name
#   virtual_network_name = azurerm_virtual_network.region1-vnet1-hub1.name
#   address_prefixes     = [var.region1-vnet1-snet1-range]
# }
# resource "azurerm_subnet" "region1-vnet1-snet2" {
#   name                 = var.region1-vnet1-snet2-name
#   resource_group_name  = azurerm_resource_group.rg1.name
#   virtual_network_name = azurerm_virtual_network.region1-vnet1-hub1.name
#   address_prefixes     = [var.region1-vnet1-snet2-range]
# }
# resource "azurerm_subnet" "region1-vnet1-snet3" {
#   name                 = var.region1-vnet1-snet3-name
#   resource_group_name  = azurerm_resource_group.rg1.name
#   virtual_network_name = azurerm_virtual_network.region1-vnet1-hub1.name
#   address_prefixes     = [var.region1-vnet1-snet3-range]
# }
# #Spoke VNET and Subnets 
# resource "azurerm_virtual_network" "region1-vnet2-spoke1" {
#   name                = var.region1-vnet2-name
#   location            = var.loc1
#   resource_group_name = azurerm_resource_group.rg1.name
#   address_space       = [var.region1-vnet2-address-space]
#   dns_servers         = ["10.10.1.4", "168.63.129.16", "8.8.8.8"]
#   tags = {
#     Environment = var.environment_tag
#     Function    = "baselabv1-network"
#   }
# }
# resource "azurerm_subnet" "region1-vnet2-snet1" {
#   name                 = var.region1-vnet2-snet1-name
#   resource_group_name  = azurerm_resource_group.rg1.name
#   virtual_network_name = azurerm_virtual_network.region1-vnet2-spoke1.name
#   address_prefixes     = [var.region1-vnet2-snet1-range]
# }
# resource "azurerm_subnet" "region1-vnet2-snet2" {
#   name                 = var.region1-vnet2-snet2-name
#   resource_group_name  = azurerm_resource_group.rg1.name
#   virtual_network_name = azurerm_virtual_network.region1-vnet2-spoke1.name
#   address_prefixes     = [var.region1-vnet2-snet2-range]
# }
# resource "azurerm_subnet" "region1-vnet2-snet3" {
#   name                 = var.region1-vnet2-snet3-name
#   resource_group_name  = azurerm_resource_group.rg1.name
#   virtual_network_name = azurerm_virtual_network.region1-vnet2-spoke1.name
#   address_prefixes     = [var.region1-vnet2-snet3-range]
#   delegation {
#     name = "delegation"
#     service_delegation {
#       name    = "Microsoft.Netapp/volumes"
#       actions = ["Microsoft.Network/networkinterfaces/*", "Microsoft.Network/virtualNetworks/subnets/join/action"]
#     }
#   }
# }
# #VNET Peering
# resource "azurerm_virtual_network_peering" "peer1" {
#   name                         = "region1-vnet1-to-region1-vnet2"
#   resource_group_name          = azurerm_resource_group.rg1.name
#   virtual_network_name         = azurerm_virtual_network.region1-vnet1-hub1.name
#   remote_virtual_network_id    = azurerm_virtual_network.region1-vnet2-spoke1.id
#   allow_virtual_network_access = true
#   allow_forwarded_traffic      = true
# }
# resource "azurerm_virtual_network_peering" "peer2" {
#   name                         = "region1-vnet2-to-region1-vnet1"
#   resource_group_name          = azurerm_resource_group.rg1.name
#   virtual_network_name         = azurerm_virtual_network.region1-vnet2-spoke1.name
#   remote_virtual_network_id    = azurerm_virtual_network.region1-vnet1-hub1.id
#   allow_virtual_network_access = true
#   allow_forwarded_traffic      = true
# }