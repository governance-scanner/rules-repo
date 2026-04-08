# Policy: AzureWindowsVMDiskSkuValidator
# Resource type: azurerm_windows_virtual_machine
# Checked attribute path: os_disk.storage_account_type
# Expected: PASS because non-production uses StandardSSD_LRS.

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg_pass_win_vm_b2" {
  name     = "rg-pass-win-vm-b2"
  location = "eastus"
}

resource "azurerm_virtual_network" "vnet_pass_win_vm_b2" {
  name                = "vnetpasswinvmb2"
  location            = azurerm_resource_group.rg_pass_win_vm_b2.location
  resource_group_name = azurerm_resource_group.rg_pass_win_vm_b2.name
  address_space       = ["10.62.0.0/16"]
}

resource "azurerm_subnet" "subnet_pass_win_vm_b2" {
  name                 = "subnetpasswinvmb2"
  resource_group_name  = azurerm_resource_group.rg_pass_win_vm_b2.name
  virtual_network_name = azurerm_virtual_network.vnet_pass_win_vm_b2.name
  address_prefixes     = ["10.62.1.0/24"]
}

resource "azurerm_network_interface" "nic_pass_win_vm_b2" {
  name                = "nicpasswinvmb2"
  location            = azurerm_resource_group.rg_pass_win_vm_b2.location
  resource_group_name = azurerm_resource_group.rg_pass_win_vm_b2.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet_pass_win_vm_b2.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "pass_win_vm_b2" {
  name                = "winvmpassb2"
  resource_group_name = azurerm_resource_group.rg_pass_win_vm_b2.name
  location            = azurerm_resource_group.rg_pass_win_vm_b2.location
  size                = "Standard_B2s"
  admin_username      = "azureuser"
  admin_password      = "P@ssword1234!"
  network_interface_ids = [azurerm_network_interface.nic_pass_win_vm_b2.id]
  tags = {
    environment = "dev"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS" # ✅ PASS: allowed lower-cost OS disk type
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }
}
