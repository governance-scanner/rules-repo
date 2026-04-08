# Policy: AzureDatabricksWorkspacePublicAccessValidator
# Resource type: azurerm_databricks_workspace
# Checked attribute path: public_network_access_enabled
# Expected: FAIL because public_network_access_enabled is omitted and the policy defaults missing values to true.

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg_fail_databricks_public" {
  name     = "rg-fail-databricks-public"
  location = "eastus"
}

resource "azurerm_databricks_workspace" "fail_databricks_public" {
  name                = "dbwfailpublicaccess"
  resource_group_name = azurerm_resource_group.rg_fail_databricks_public.name
  location            = azurerm_resource_group.rg_fail_databricks_public.location
  sku                 = "standard"
  # ❌ FAIL: public_network_access_enabled omitted, scanner treats missing as true
}
