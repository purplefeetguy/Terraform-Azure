# #RDP Access Rules for Lab
# # #Get Client IP Address for NSG
# # data "http" "clientip" {
# #   url = "https://ipv4.icanhazip.com/"
# # }
# #Lab NSG
# resource "azurerm_network_security_group" "region1-nsg" {
#   name                = "region1-nsg"
#   location            = var.loc1
#   resource_group_name = azurerm_resource_group.rg2.name

#   security_rule {
#     name                       = "RDP-In"
#     priority                   = 100
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "*"
#     source_port_range          = "*"
#     destination_port_range     = "3389"
#     source_address_prefix      = "${chomp(data.http.clientip.body)}/32"
#     destination_address_prefix = "*"
#   }

#   security_rule {
#     name                       = "SSH-In"
#     priority                   = 101
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "*"
#     source_port_range          = "*"
#     destination_port_range     = "22"
#     source_address_prefix      = "${chomp(data.http.clientip.body)}/32"
#     destination_address_prefix = "*"
#   }
#   tags = {
#     Environment = var.environment_tag
#     Function    = "stiglabv1-security"
#   }
# }
# #NSG Association to all Lab Subnets
# resource "azurerm_subnet_network_security_group_association" "vnet1-snet1" {
#   subnet_id                 = azurerm_subnet.region1-vnet1-snet1.id
#   network_security_group_id = azurerm_network_security_group.region1-nsg.id
# }
# resource "azurerm_subnet_network_security_group_association" "vnet1-snet2" {
#   subnet_id                 = azurerm_subnet.region1-vnet1-snet2.id
#   network_security_group_id = azurerm_network_security_group.region1-nsg.id
# }
# resource "azurerm_subnet_network_security_group_association" "vnet1-snet3" {
#   subnet_id                 = azurerm_subnet.region1-vnet1-snet3.id
#   network_security_group_id = azurerm_network_security_group.region1-nsg.id
# }
# resource "azurerm_subnet_network_security_group_association" "vnet2-snet1" {
#   subnet_id                 = azurerm_subnet.region1-vnet2-snet1.id
#   network_security_group_id = azurerm_network_security_group.region1-nsg.id
# }
# resource "azurerm_subnet_network_security_group_association" "vnet2-snet2" {
#   subnet_id                 = azurerm_subnet.region1-vnet2-snet2.id
#   network_security_group_id = azurerm_network_security_group.region1-nsg.id
# }