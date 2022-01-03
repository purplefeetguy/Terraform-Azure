#Create Azure Shared Image Gallery 
resource "azurerm_shared_image_gallery" "stiglabv1images" {
  name                = "stiglabv1images"
  resource_group_name = azurerm_resource_group.rg3.name
  location            = var.loc1
  description         = "Shared images for this environment."

  tags     = {
       Environment  = var.environment_tag
   }
}