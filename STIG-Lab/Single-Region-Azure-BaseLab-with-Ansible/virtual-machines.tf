# #Public IP - Windows VM
# resource "azurerm_public_ip" "region1-dc01-pip" {
#   name                = "region1-dc01-pip"
#   resource_group_name = azurerm_resource_group.rg1.name
#   location            = var.loc1
#   allocation_method   = "Static"
#   sku                 = "Standard"

#   tags = {
#     Environment = var.environment_tag
#     Function    = "stiglabv1-activedirectory"
#   }
# }
# #Create NIC and associate the Public IP - Windows VM
# resource "azurerm_network_interface" "region1-dc01-nic" {
#   name                = "region1-dc01-nic"
#   location            = var.loc1
#   resource_group_name = azurerm_resource_group.rg1.name


#   ip_configuration {
#     name                          = "region1-dc01-ipconfig"
#     subnet_id                     = azurerm_subnet.region1-vnet1-snet1.id
#     private_ip_address_allocation = "Dynamic"
#     public_ip_address_id          = azurerm_public_ip.region1-dc01-pip.id
#   }

#   tags = {
#     Environment = var.environment_tag
#     Function    = "stiglabv1-activedirectory"
#   }
# }
# #Public IP - Ansible VM
# resource "azurerm_public_ip" "region1-an01-pip" {
#   name                = "region1-an01-pip"
#   resource_group_name = azurerm_resource_group.rg1.name
#   location            = var.loc1
#   allocation_method   = "Static"
#   sku                 = "Standard"

#   tags = {
#     Environment = var.environment_tag
#     Function    = "stiglabv1-ansible"
#   }
# }
# #Create NIC and associate the Public IP - Ansible VM
# resource "azurerm_network_interface" "region1-an01-nic" {
#   name                = "region1-an01-nic"
#   location            = var.loc1
#   resource_group_name = azurerm_resource_group.rg1.name


#   ip_configuration {
#     name                          = "region1-an01-ipconfig"
#     subnet_id                     = azurerm_subnet.region1-vnet1-snet1.id
#     private_ip_address_allocation = "Dynamic"
#     public_ip_address_id          = azurerm_public_ip.region1-an01-pip.id
#   }

#   tags = {
#     Environment = var.environment_tag
#     Function    = "stiglabv1-ansible"
#   }
# }
# #Create data disk for NTDS storage
# resource "azurerm_managed_disk" "region1-dc01-data" {
#   name                 = "region1-dc01-data"
#   location             = var.loc1
#   resource_group_name  = azurerm_resource_group.rg1.name
#   storage_account_type = "StandardSSD_LRS"
#   create_option        = "Empty"
#   disk_size_gb         = "20"
#   max_shares           = "2"

#   tags = {
#     Environment = var.environment_tag
#     Function    = "stiglabv1-activedirectory"
#   }
# }
# #Create Domain Controller VM
# resource "azurerm_windows_virtual_machine" "region1-dc01-vm" {
#   name                = "region1-dc01-vm"
#   depends_on          = [azurerm_key_vault.kv1]
#   resource_group_name = azurerm_resource_group.rg1.name
#   location            = var.loc1
#   size                = var.vmsize
#   admin_username      = var.adminusername
#   admin_password      = azurerm_key_vault_secret.vmpassword.value
#   network_interface_ids = [
#     azurerm_network_interface.region1-dc01-nic.id,
#   ]

#   tags = {
#     Environment = var.environment_tag
#     Function    = "stiglabv1-activedirectory"
#   }

#   os_disk {
#     caching              = "ReadWrite"
#     storage_account_type = "StandardSSD_LRS"
#   }

#   source_image_reference {
#     publisher = "MicrosoftWindowsServer"
#     offer     = "WindowsServer"
#     sku       = "2019-Datacenter"
#     version   = "latest"
#   }
# }
# #Attach Data Disk to Virtual Machine
# resource "azurerm_virtual_machine_data_disk_attachment" "region1-dc01-data" {
#   managed_disk_id    = azurerm_managed_disk.region1-dc01-data.id
#   depends_on         = [azurerm_windows_virtual_machine.region1-dc01-vm]
#   virtual_machine_id = azurerm_windows_virtual_machine.region1-dc01-vm.id
#   lun                = "10"
#   caching            = "None"
# }
# #Run setup script on dc01-vm
# resource "azurerm_virtual_machine_extension" "region1-dc01-stigsetup" {
#   name                 = "region1-dc01-stigsetup"
#   virtual_machine_id   = azurerm_windows_virtual_machine.region1-dc01-vm.id
#   depends_on           = [azurerm_virtual_machine_data_disk_attachment.region1-dc01-data]
#   publisher            = "Microsoft.Compute"
#   type                 = "CustomScriptExtension"
#   type_handler_version = "1.9"

#   protected_settings = <<PROTECTED_SETTINGS
#     {
#       "commandToExecute": "powershell.exe -Command \"./stiglab_DCSetup.ps1; exit 0;\""
#     }
#   PROTECTED_SETTINGS

#   settings = <<SETTINGS
#     {
#         "fileUris": [
#           "https://raw.githubusercontent.com/purplefeetguy/STIG-Lab/Terraform-Azure/main/Single-Region-Azure-stigLab-with-Ansible/PowerShell/stiglab_DCSetup.ps1"
#         ]
#     }
#   SETTINGS
# }
# #Create Ansible VM
# resource "azurerm_linux_virtual_machine" "region1-an01-vm" {
#   name                            = "region1-an01-vm"
#   resource_group_name             = azurerm_resource_group.rg1.name
#   location                        = var.loc1
#   size                            = var.vmsize
#   admin_username                  = var.adminusername
#   admin_password                  = azurerm_key_vault_secret.anpassword.value
#   disable_password_authentication = false
#   network_interface_ids = [
#     azurerm_network_interface.region1-an01-nic.id,
#   ]

#   os_disk {
#     caching              = "ReadWrite"
#     storage_account_type = "StandardSSD_LRS"
#   }

#   source_image_reference {
#     publisher = "Canonical"
#     offer     = "UbuntuServer"
#     sku       = "18.04-LTS"
#     version   = "latest"
#   }
#   tags = {
#     Environment = var.environment_tag
#     Function    = "stiglabv1-ansible"
#   }
# }
# #Run setup script on an01-vm
# resource "azurerm_virtual_machine_extension" "region1-an01-stigsetup" {
#   name                 = "region1-an01-stigsetup"
#   virtual_machine_id   = azurerm_linux_virtual_machine.region1-an01-vm.id
#   publisher            = "Microsoft.Azure.Extensions"
#   type                 = "CustomScript"
#   type_handler_version = "2.0"

#   settings = <<SETTINGS
#     {
#         "commandToExecute": "bash AnsibleSetup.sh",
#         "fileUris": [
#           "https://raw.githubusercontent.com/jakewalsh90/Terraform-Azure/main/Single-Region-Azure-stigLab-with-Ansible/Ansible/AnsibleSetup.sh"
#         ]
#     }
#   SETTINGS
# }
