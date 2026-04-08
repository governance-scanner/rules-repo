# Policy: AzureVMDiskDeletionOnTerminationValidator
# Resource type: azurerm_virtual_machine
# Checked attribute paths: delete_os_disk_on_termination, delete_data_disks_on_termination
# Expected: FAIL because data disk deletion is disabled while OS disk deletion remains enabled.

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg_fail_vm_delete_data_b2" {
  name     = "rg-fail-vm-del-data-b2"
  location = "eastus"
}

resource "azurerm_virtual_network" "vnet_fail_vm_delete_data_b2" {
  name                = "vnetfailvmdeldtb2"
  location            = azurerm_resource_group.rg_fail_vm_delete_data_b2.location
  resource_group_name = azurerm_resource_group.rg_fail_vm_delete_data_b2.name
  address_space       = ["10.66.0.0/16"]
}

resource "azurerm_subnet" "subnet_fail_vm_delete_data_b2" {
  name                 = "subnetfailvmdeldtb2"
  resource_group_name  = azurerm_resource_group.rg_fail_vm_delete_data_b2.name
  virtual_network_name = azurerm_virtual_network.vnet_fail_vm_delete_data_b2.name
  address_prefixes     = ["10.66.1.0/24"]
}

resource "azurerm_network_interface" "nic_fail_vm_delete_data_b2" {
  name                = "nicfailvmdeldtb2"
  location            = azurerm_resource_group.rg_fail_vm_delete_data_b2.location
  resource_group_name = azurerm_resource_group.rg_fail_vm_delete_data_b2.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet_fail_vm_delete_data_b2.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "fail_vm_delete_data_b2" {
  name                          = "vmdeldtfailb2"
  location                      = azurerm_resource_group.rg_fail_vm_delete_data_b2.location
  resource_group_name           = azurerm_resource_group.rg_fail_vm_delete_data_b2.name
  network_interface_ids         = [azurerm_network_interface.nic_fail_vm_delete_data_b2.id]
  vm_size                       = "Standard_B1s"
  delete_os_disk_on_termination = true # ✅ Passes the OS disk branch
  delete_data_disks_on_termination = false # ❌ FAIL: data disks can remain orphaned

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "osdiskdeletefaildtb2"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_data_disk {
    name              = "datadiskdeletefaildtb2"
    managed_disk_type = "Standard_LRS"
    create_option     = "Empty"
    lun               = 0
    disk_size_gb      = 32
  }

  os_profile {
    computer_name  = "vmdeldtfail"
    admin_username = "azureuser"
    admin_password = "P@ssword1234!"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}
