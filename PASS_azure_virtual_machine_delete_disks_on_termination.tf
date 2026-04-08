# Policy: AzureVMDiskDeletionOnTerminationValidator
# Resource type: azurerm_virtual_machine
# Checked attribute paths: delete_os_disk_on_termination, delete_data_disks_on_termination
# Expected: PASS because both deletion flags are explicitly true.

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg_pass_vm_delete_b2" {
  name     = "rg-pass-vm-delete-b2"
  location = "eastus"
}

resource "azurerm_virtual_network" "vnet_pass_vm_delete_b2" {
  name                = "vnetpassvmdeleteb2"
  location            = azurerm_resource_group.rg_pass_vm_delete_b2.location
  resource_group_name = azurerm_resource_group.rg_pass_vm_delete_b2.name
  address_space       = ["10.64.0.0/16"]
}

resource "azurerm_subnet" "subnet_pass_vm_delete_b2" {
  name                 = "subnetpassvmdeleteb2"
  resource_group_name  = azurerm_resource_group.rg_pass_vm_delete_b2.name
  virtual_network_name = azurerm_virtual_network.vnet_pass_vm_delete_b2.name
  address_prefixes     = ["10.64.1.0/24"]
}

resource "azurerm_network_interface" "nic_pass_vm_delete_b2" {
  name                = "nicpassvmdeleteb2"
  location            = azurerm_resource_group.rg_pass_vm_delete_b2.location
  resource_group_name = azurerm_resource_group.rg_pass_vm_delete_b2.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet_pass_vm_delete_b2.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "pass_vm_delete_b2" {
  name                          = "vmdeletepassb2"
  location                      = azurerm_resource_group.rg_pass_vm_delete_b2.location
  resource_group_name           = azurerm_resource_group.rg_pass_vm_delete_b2.name
  network_interface_ids         = [azurerm_network_interface.nic_pass_vm_delete_b2.id]
  vm_size                       = "Standard_B1s"
  delete_os_disk_on_termination = true # ✅ PASS: OS disk will be removed with the VM
  delete_data_disks_on_termination = true # ✅ PASS: data disks will be removed with the VM

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "osdiskdeletepassb2"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_data_disk {
    name              = "datadiskdeletepassb2"
    managed_disk_type = "Standard_LRS"
    create_option     = "Empty"
    lun               = 0
    disk_size_gb      = 32
  }

  os_profile {
    computer_name  = "vmdeletepass"
    admin_username = "azureuser"
    admin_password = "P@ssword1234!"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}
