# Policy: AzureVMSkuRestrictionValidator
# Resource type: azurerm_virtual_machine
# Checked attribute path: vm_size
# Expected: PASS because the non-production VM uses an allowlisted size.

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg_pass_vm_sku_b4" {
  name     = "rg-pass-vm-sku-b4"
  location = "eastus"
}

resource "azurerm_virtual_network" "vnet_pass_vm_sku_b4" {
  name                = "vnetpassvmskub4"
  location            = azurerm_resource_group.rg_pass_vm_sku_b4.location
  resource_group_name = azurerm_resource_group.rg_pass_vm_sku_b4.name
  address_space       = ["10.70.0.0/16"]
}

resource "azurerm_subnet" "subnet_pass_vm_sku_b4" {
  name                 = "subnetpassvmskub4"
  resource_group_name  = azurerm_resource_group.rg_pass_vm_sku_b4.name
  virtual_network_name = azurerm_virtual_network.vnet_pass_vm_sku_b4.name
  address_prefixes     = ["10.70.1.0/24"]
}

resource "azurerm_network_interface" "nic_pass_vm_sku_b4" {
  name                = "nicpassvmskub4"
  location            = azurerm_resource_group.rg_pass_vm_sku_b4.location
  resource_group_name = azurerm_resource_group.rg_pass_vm_sku_b4.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet_pass_vm_sku_b4.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "pass_vm_sku_b4" {
  name                = "vmpassskub4"
  location            = azurerm_resource_group.rg_pass_vm_sku_b4.location
  resource_group_name = azurerm_resource_group.rg_pass_vm_sku_b4.name
  network_interface_ids = [azurerm_network_interface.nic_pass_vm_sku_b4.id]
  vm_size             = "Standard_B2s" # ✅ PASS: allowlisted non-production size
  tags = {
    environment = "dev"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "osdiskpassvmskub4"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "vmpassskub4"
    admin_username = "azureuser"
    admin_password = "P@ssword1234!"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}
