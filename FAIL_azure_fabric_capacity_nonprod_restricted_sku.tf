# Policy: AzureFabricSkuValidator
# Resource type: azurerm_fabric_capacity
# Checked attribute path: sku.name
# Expected: FAIL because non-production capacity uses restricted SKU F64.

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg_fail_fabric_sku" {
  name     = "rg-fail-fabric-sku"
  location = "eastus"
}

resource "azurerm_fabric_capacity" "fail_fabric_sku" {
  name                = "fabricfailsku"
  location            = azurerm_resource_group.rg_fail_fabric_sku.location
  resource_group_name = azurerm_resource_group.rg_fail_fabric_sku.name
  administration_members = ["admin@example.com"]
  sku {
    name = "F64" # ❌ FAIL: matches governance restricted_skus
    tier = "Fabric"
  }
  tags = {
    environment = "dev"
  }
}
