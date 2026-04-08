# Policy: AzureFabricSkuValidator
# Resource type: azurerm_fabric_capacity
# Checked attribute path: sku.name
# Expected: PASS because non-production capacity uses a SKU outside restricted_skus.

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg_pass_fabric_sku" {
  name     = "rg-pass-fabric-sku"
  location = "eastus"
}

resource "azurerm_fabric_capacity" "pass_fabric_sku" {
  name                = "fabricpasssku"
  location            = azurerm_resource_group.rg_pass_fabric_sku.location
  resource_group_name = azurerm_resource_group.rg_pass_fabric_sku.name
  administration_members = ["admin@example.com"]
  sku {
    name = "F32" # ✅ PASS: not in governance restricted_skus ["F64"]
    tier = "Fabric"
  }
  tags = {
    environment = "dev"
  }
}
