#Resource Groups
resource "azurerm_resource_group" "rg1" {
  name     = var.azure-rg-1
  location = var.loc1
  tags = {
    Environment = var.environment_tag
    Function    = "stiglabv1-resourcegroups"
    CostCenter  = "MBoudro"
  }
}
#Resource Groups
resource "azurerm_resource_group" "rg2" {
  name     = var.azure-rg-2
  location = var.loc1
  tags = {
    Environment = var.environment_tag
    Function    = "stiglabv1-resourcegroups"
    CostCenter  = "MBoudro"
  }
}
