# Policy: AzureVMSkuRestrictionValidator
# Resource type: azurerm_virtual_machine
# Checked attribute path: vm_size
# Expected: FAIL because the non-production VM uses a size outside the allowlist.

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg_fail_vm_sku_b4" {
  name     = "rg-fail-vm-sku-b4"
  location = "eastus"
}

resource "azurerm_virtual_network" "vnet_fail_vm_sku_b4" {
  name                = "vnetfailvmskub4"
  location            = azurerm_resource_group.rg_fail_vm_sku_b4.location
  resource_group_name = azurerm_resource_group.rg_fail_vm_sku_b4.name
  address_space       = ["10.71.0.0/16"]
}

resource "azurerm_subnet" "subnet_fail_vm_sku_b4" {
  name                 = "subnetfailvmskub4"
  resource_group_name  = azurerm_resource_group.rg_fail_vm_sku_b4.name
  virtual_network_name = azurerm_virtual_network.vnet_fail_vm_sku_b4.name
  address_prefixes     = ["10.71.1.0/24"]
}

resource "azurerm_network_interface" "nic_fail_vm_sku_b4" {
  name                = "nicfailvmskub4"
  location            = azurerm_resource_group.rg_fail_vm_sku_b4.location
  resource_group_name = azurerm_resource_group.rg_fail_vm_sku_b4.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet_fail_vm_sku_b4.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "fail_vm_sku_b4" {
  name                = "vmfailskub4"
  location            = azurerm_resource_group.rg_fail_vm_sku_b4.location
  resource_group_name = azurerm_resource_group.rg_fail_vm_sku_b4.name
  network_interface_ids = [azurerm_network_interface.nic_fail_vm_sku_b4.id]
  vm_size             = "Standard_D16s_v3" # ❌ FAIL: not in the allowlisted non-production sizes
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
    name              = "osdiskfailvmskub4"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "vmfailskub4"
    admin_username = "azureuser"
    admin_password = "P@ssword1234!"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}
