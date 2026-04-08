# Policy: AzurePrivateEndpointServiceConnectionValidator
# Resource type: azurerm_private_endpoint
# Checked attribute path: private_service_connection.private_connection_resource_id
# Expected: PASS because private_connection_resource_id is explicitly set.

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg_pass_pe_b2" {
  name     = "rg-pass-pe-b2"
  location = "eastus"
}

resource "azurerm_virtual_network" "vnet_pass_pe_b2" {
  name                = "vnetpasspeb2"
  location            = azurerm_resource_group.rg_pass_pe_b2.location
  resource_group_name = azurerm_resource_group.rg_pass_pe_b2.name
  address_space       = ["10.50.0.0/16"]
}

resource "azurerm_subnet" "subnet_pass_pe_b2" {
  name                 = "subnetpasspeb2"
  resource_group_name  = azurerm_resource_group.rg_pass_pe_b2.name
  virtual_network_name = azurerm_virtual_network.vnet_pass_pe_b2.name
  address_prefixes     = ["10.50.1.0/24"]
}

resource "azurerm_storage_account" "sa_pass_pe_b2" {
  name                     = "sapasspebatchtwo01"
  resource_group_name      = azurerm_resource_group.rg_pass_pe_b2.name
  location                 = azurerm_resource_group.rg_pass_pe_b2.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_private_endpoint" "pass_pe_b2" {
  name                = "pep-pass-b2"
  location            = azurerm_resource_group.rg_pass_pe_b2.location
  resource_group_name = azurerm_resource_group.rg_pass_pe_b2.name
  subnet_id           = azurerm_subnet.subnet_pass_pe_b2.id

  private_service_connection {
    name                           = "pscpassb2"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_storage_account.sa_pass_pe_b2.id # ✅ PASS: resource ID is provided
    subresource_names              = ["blob"]
  }
}
