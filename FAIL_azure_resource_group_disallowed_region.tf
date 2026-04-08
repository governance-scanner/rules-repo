# Policy: AzureRegionRestrictionValidator
# Resource type: azurerm_resource_group
# Checked attribute path: location
# Expected: FAIL because centralus is outside the approved region list.

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "fail_region_b2" {
  name     = "rg-fail-region-b2"
  location = "centralus" # ❌ FAIL: not in [eastus, westeurope, uksouth]
}
