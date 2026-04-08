# Policy: AzureVmShutdownValidation
# Resource type: azurerm_dev_test_global_vm_shutdown_schedule
# Checked attribute path: enabled
# Expected: FAIL because auto-shutdown is explicitly disabled for a non-production VM.

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg_fail_shutdown_b2" {
  name     = "rg-fail-shutdown-b2"
  location = "eastus"
}

resource "azurerm_virtual_network" "vnet_fail_shutdown_b2" {
  name                = "vnetfailshutdownb2"
  location            = azurerm_resource_group.rg_fail_shutdown_b2.location
  resource_group_name = azurerm_resource_group.rg_fail_shutdown_b2.name
  address_space       = ["10.61.0.0/16"]
}

resource "azurerm_subnet" "subnet_fail_shutdown_b2" {
  name                 = "subnetfailshutdownb2"
  resource_group_name  = azurerm_resource_group.rg_fail_shutdown_b2.name
  virtual_network_name = azurerm_virtual_network.vnet_fail_shutdown_b2.name
  address_prefixes     = ["10.61.1.0/24"]
}

resource "azurerm_network_interface" "nic_fail_shutdown_b2" {
  name                = "nicfailshutdownb2"
  location            = azurerm_resource_group.rg_fail_shutdown_b2.location
  resource_group_name = azurerm_resource_group.rg_fail_shutdown_b2.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet_fail_shutdown_b2.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "vm_fail_shutdown_b2" {
  name                = "vmfailshutdownb2"
  resource_group_name = azurerm_resource_group.rg_fail_shutdown_b2.name
  location            = azurerm_resource_group.rg_fail_shutdown_b2.location
  size                = "Standard_B1s"
  admin_username      = "azureuser"
  admin_password      = "P@ssword1234!"
  disable_password_authentication = false
  network_interface_ids = [azurerm_network_interface.nic_fail_shutdown_b2.id]
  tags = {
    environment = "dev"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
}

resource "azurerm_dev_test_global_vm_shutdown_schedule" "fail_shutdown_b2" {
  virtual_machine_id    = azurerm_linux_virtual_machine.vm_fail_shutdown_b2.id
  location              = azurerm_resource_group.rg_fail_shutdown_b2.location
  enabled               = false # ❌ FAIL: shutdown schedule is disabled
  daily_recurrence_time = "1900"
  timezone              = "UTC"
  tags = {
    environment = "dev"
  }

  notification_settings {
    enabled = false
  }
}
