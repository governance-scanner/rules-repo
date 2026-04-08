# Policy: AzureVmShutdownValidation
# Resource type: azurerm_dev_test_global_vm_shutdown_schedule
# Checked attribute path: enabled
# Expected: PASS because auto-shutdown is explicitly enabled for a non-production VM.

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg_pass_shutdown_b2" {
  name     = "rg-pass-shutdown-b2"
  location = "eastus"
}

resource "azurerm_virtual_network" "vnet_pass_shutdown_b2" {
  name                = "vnetpassshutdownb2"
  location            = azurerm_resource_group.rg_pass_shutdown_b2.location
  resource_group_name = azurerm_resource_group.rg_pass_shutdown_b2.name
  address_space       = ["10.60.0.0/16"]
}

resource "azurerm_subnet" "subnet_pass_shutdown_b2" {
  name                 = "subnetpassshutdownb2"
  resource_group_name  = azurerm_resource_group.rg_pass_shutdown_b2.name
  virtual_network_name = azurerm_virtual_network.vnet_pass_shutdown_b2.name
  address_prefixes     = ["10.60.1.0/24"]
}

resource "azurerm_network_interface" "nic_pass_shutdown_b2" {
  name                = "nicpassshutdownb2"
  location            = azurerm_resource_group.rg_pass_shutdown_b2.location
  resource_group_name = azurerm_resource_group.rg_pass_shutdown_b2.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet_pass_shutdown_b2.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "vm_pass_shutdown_b2" {
  name                = "vmpassshutdownb2"
  resource_group_name = azurerm_resource_group.rg_pass_shutdown_b2.name
  location            = azurerm_resource_group.rg_pass_shutdown_b2.location
  size                = "Standard_B1s"
  admin_username      = "azureuser"
  admin_password      = "P@ssword1234!"
  disable_password_authentication = false
  network_interface_ids = [azurerm_network_interface.nic_pass_shutdown_b2.id]
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

resource "azurerm_dev_test_global_vm_shutdown_schedule" "pass_shutdown_b2" {
  virtual_machine_id    = azurerm_linux_virtual_machine.vm_pass_shutdown_b2.id
  location              = azurerm_resource_group.rg_pass_shutdown_b2.location
  enabled               = true # ✅ PASS: shutdown schedule is enabled
  daily_recurrence_time = "1900"
  timezone              = "UTC"
  tags = {
    environment = "dev"
  }

  notification_settings {
    enabled = false
  }
}
