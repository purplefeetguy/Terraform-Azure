#Public IP
resource "azurerm_public_ip" "region1-dc01-pip" {
  name                = "region1-dc01-pip"
  resource_group_name = azurerm_resource_group.rg1.name
  location            = var.loc1
  allocation_method   = "Static"
  sku = "Standard"

   tags     = {
       Environment  = var.environment_tag
   }
}
#Create NIC and associate the Public IP
resource "azurerm_network_interface" "region1-dc01-nic" {
  name                = "region1-dc01-nic"
  location            = var.loc1
  resource_group_name = azurerm_resource_group.rg1.name


  ip_configuration {
    name                          = "region1-dc01-ipconfig"
    subnet_id                     = azurerm_subnet.region1-vnet1-snet1.id
    private_ip_address_allocation = "Static"
    private_ip_address = "10.100.1.4"
	  public_ip_address_id = azurerm_public_ip.region1-dc01-pip.id
  }
  
   tags     = {
       Environment  = var.environment_tag
   }
}
#Create data disk for NTDS storage
resource "azurerm_managed_disk" "region1-dc01-data" {
  name                 = "region1-dc01-data"
  location             = var.loc1
  resource_group_name  = azurerm_resource_group.rg1.name
  storage_account_type = "StandardSSD_LRS"
  create_option        = "Empty"
  disk_size_gb         = "5"

  tags  = {
    Environment  = var.environment_tag
  }
}
#Create Domain Controller VM
resource "azurerm_windows_virtual_machine" "region1-dc01-vm" {
  name                = "region1-dc01-vm"
  depends_on = [ azurerm_key_vault.kv1 ]
  resource_group_name = azurerm_resource_group.rg1.name
  location            = var.loc1
  size                = var.vmsize-domaincontroller
  admin_username      = var.adminusername
  admin_password      = azurerm_key_vault_secret.vmpassword.value
  network_interface_ids = [
    azurerm_network_interface.region1-dc01-nic.id,
  ]

  tags     = {
       Environment  = var.environment_tag
   }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}
#Attach Data Disk to Virtual Machine
resource "azurerm_virtual_machine_data_disk_attachment" "region1-dc01-data" {
  managed_disk_id    = azurerm_managed_disk.region1-dc01-data.id
  depends_on = [ azurerm_windows_virtual_machine.region1-dc01-vm ]
  virtual_machine_id = azurerm_windows_virtual_machine.region1-dc01-vm.id
  lun                = "10"
  caching            = "None"
  }
#Run setup script on dc01-vm
resource "azurerm_virtual_machine_extension" "region1-dc01-basesetup" {
  name                 = "region1-dc01-basesetup"
  virtual_machine_id   = azurerm_windows_virtual_machine.region1-dc01-vm.id
  depends_on = [ azurerm_virtual_machine_data_disk_attachment.region1-dc01-data ]
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"

  protected_settings = <<PROTECTED_SETTINGS
    {
      "commandToExecute": "powershell.exe -Command \"./baselab_DCSetup.ps1; exit 0;\""
    }
  PROTECTED_SETTINGS

  settings = <<SETTINGS
    {
        "fileUris": [
          "https://raw.githubusercontent.com/jakewalsh90/Terraform-Azure/main/Azure-DevOps-WVD/Single-Region-BaseLab/PowerShell/baselab_DCSetup.ps1"
        ]
    }
  SETTINGS
}