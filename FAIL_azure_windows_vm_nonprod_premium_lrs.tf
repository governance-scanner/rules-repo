# Policy: AzureWindowsVMDiskSkuValidator
# Resource type: azurerm_windows_virtual_machine
# Checked attribute path: os_disk.storage_account_type
# Expected: FAIL because non-production uses Premium_LRS.

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg_fail_win_vm_b2" {
  name     = "rg-fail-win-vm-b2"
  location = "eastus"
}

resource "azurerm_virtual_network" "vnet_fail_win_vm_b2" {
  name                = "vnetfailwinvmb2"
  location            = azurerm_resource_group.rg_fail_win_vm_b2.location
  resource_group_name = azurerm_resource_group.rg_fail_win_vm_b2.name
  address_space       = ["10.63.0.0/16"]
}

resource "azurerm_subnet" "subnet_fail_win_vm_b2" {
  name                 = "subnetfailwinvmb2"
  resource_group_name  = azurerm_resource_group.rg_fail_win_vm_b2.name
  virtual_network_name = azurerm_virtual_network.vnet_fail_win_vm_b2.name
  address_prefixes     = ["10.63.1.0/24"]
}

resource "azurerm_network_interface" "nic_fail_win_vm_b2" {
  name                = "nicfailwinvmb2"
  location            = azurerm_resource_group.rg_fail_win_vm_b2.location
  resource_group_name = azurerm_resource_group.rg_fail_win_vm_b2.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet_fail_win_vm_b2.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "fail_win_vm_b2" {
  name                = "winvmfailb2"
  resource_group_name = azurerm_resource_group.rg_fail_win_vm_b2.name
  location            = azurerm_resource_group.rg_fail_win_vm_b2.location
  size                = "Standard_B2s"
  admin_username      = "azureuser"
  admin_password      = "P@ssword1234!"
  network_interface_ids = [azurerm_network_interface.nic_fail_win_vm_b2.id]
  tags = {
    environment = "dev"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS" # ❌ FAIL: blocked by the non-production disk SKU policy
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }
}
