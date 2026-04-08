# Policy: AzureRegionRestrictionValidator
# Resource type: azurerm_resource_group
# Checked attribute path: location
# Expected: PASS because eastus is in the approved region list.

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "pass_region_b2" {
  name     = "rg-pass-region-b2"
  location = "eastus" # ✅ PASS: approved region from governance input_details
}
