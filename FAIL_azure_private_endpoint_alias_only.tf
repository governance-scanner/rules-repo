# Policy: AzurePrivateEndpointServiceConnectionValidator
# Resource type: azurerm_private_endpoint
# Checked attribute path: private_service_connection.private_connection_resource_id
# Expected: FAIL for the current scanner because only private_connection_resource_alias is set.
# This file is doc-aligned to the latest provider docs and is recorded as scanner-risky in DOC_ALIGNED_SCANNER_RISKS.md.

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg_fail_pe_b2" {
  name     = "rg-fail-pe-b2"
  location = "eastus"
}

resource "azurerm_virtual_network" "vnet_fail_pe_b2" {
  name                = "vnetfailpeb2"
  location            = azurerm_resource_group.rg_fail_pe_b2.location
  resource_group_name = azurerm_resource_group.rg_fail_pe_b2.name
  address_space       = ["10.51.0.0/16"]
}

resource "azurerm_subnet" "subnet_fail_pe_b2" {
  name                 = "subnetfailpeb2"
  resource_group_name  = azurerm_resource_group.rg_fail_pe_b2.name
  virtual_network_name = azurerm_virtual_network.vnet_fail_pe_b2.name
  address_prefixes     = ["10.51.1.0/24"]
}

resource "azurerm_private_endpoint" "fail_pe_b2" {
  name                = "pep-fail-b2"
  location            = azurerm_resource_group.rg_fail_pe_b2.location
  resource_group_name = azurerm_resource_group.rg_fail_pe_b2.name
  subnet_id           = azurerm_subnet.subnet_fail_pe_b2.id

  private_service_connection {
    name                              = "pscfailb2"
    is_manual_connection              = true
    private_connection_resource_alias = "example.privatelinkservice" # ❌ FAIL: doc-aligned alias path, but scanner only checks private_connection_resource_id
  }
}
