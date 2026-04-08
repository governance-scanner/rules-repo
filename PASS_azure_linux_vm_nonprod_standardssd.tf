# Policy: AzureLinuxVMDiskSkuValidator
# Resource type: azurerm_linux_virtual_machine
# Checked attribute path: os_disk.storage_account_type
# Expected: PASS because non-production VM uses StandardSSD_LRS.

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg_pass_linux_vm_disk" {
  name     = "rg-pass-linux-vm-disk"
  location = "eastus"
}

resource "azurerm_virtual_network" "vnet_pass_linux_vm_disk" {
  name                = "vnet-pass-linux-vm-disk"
  location            = azurerm_resource_group.rg_pass_linux_vm_disk.location
  resource_group_name = azurerm_resource_group.rg_pass_linux_vm_disk.name
  address_space       = ["10.70.0.0/16"]
}

resource "azurerm_subnet" "subnet_pass_linux_vm_disk" {
  name                 = "snet-pass-linux-vm-disk"
  resource_group_name  = azurerm_resource_group.rg_pass_linux_vm_disk.name
  virtual_network_name = azurerm_virtual_network.vnet_pass_linux_vm_disk.name
  address_prefixes     = ["10.70.1.0/24"]
}

resource "azurerm_network_interface" "nic_pass_linux_vm_disk" {
  name                = "nic-pass-linux-vm-disk"
  location            = azurerm_resource_group.rg_pass_linux_vm_disk.location
  resource_group_name = azurerm_resource_group.rg_pass_linux_vm_disk.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet_pass_linux_vm_disk.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "pass_linux_vm_disk" {
  name                = "vm-pass-linux-disk"
  resource_group_name = azurerm_resource_group.rg_pass_linux_vm_disk.name
  location            = azurerm_resource_group.rg_pass_linux_vm_disk.location
  size                = "Standard_B2s"
  admin_username      = "azureuser"
  network_interface_ids = [azurerm_network_interface.nic_pass_linux_vm_disk.id]
  disable_password_authentication = true
  tags = {
    environment = "dev"
  }

  admin_ssh_key {
    username   = "azureuser"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCyPassLinuxVmDiskScannerKey"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS" # ✅ PASS: not in blocked_skus
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}
