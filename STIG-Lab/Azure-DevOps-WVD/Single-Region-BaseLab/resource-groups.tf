
resource "azurerm_resource_group" "rg1" {
  name     = var.azure-rg-1
  location = var.loc1
  tags = {
    Environment = var.environment_tag
  }
}
resource "azurerm_resource_group" "rg2" {
  name     = var.azure-rg-2
  location = var.loc1
  tags = {
    Environment = var.environment_tag
  }
}
resource "azurerm_resource_group" "rg3" {
  name     = var.azure-rg-3
  location = var.loc1
  tags = {
    Environment = var.environment_tag
  }
}