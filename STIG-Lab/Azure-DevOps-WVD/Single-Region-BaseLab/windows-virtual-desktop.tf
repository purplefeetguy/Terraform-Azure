# #Create Windows Virtual Desktop elements
# resource "azurerm_virtual_desktop_host_pool" "stiglab-hp1" {
#   location            = "EastUS"
#   resource_group_name = azurerm_resource_group.rg1.name

#   name                     = "stiglab-hp1"
#   friendly_name            = "stiglab-hp1"
#   validate_environment     = false
#   description              = "Acceptance Test: A pooled host pool - pooleddepthfirst"
#   type                     = "Pooled"
#   maximum_sessions_allowed = 50
#   load_balancer_type       = "DepthFirst"
# }
# resource "azurerm_virtual_desktop_workspace" "workspace" {
#   name                = "stiglab-ws1"
#   location            = "EastUS"
#   resource_group_name = azurerm_resource_group.rg1.name

#   friendly_name = "stiglab WVD Workspace"
#   description   = "stiglab Windows Virtual Desktop Workspace"
# }