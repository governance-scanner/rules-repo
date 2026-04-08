# Policy: AzureDatabricksWorkspacePublicAccessValidator
# Resource type: azurerm_databricks_workspace
# Checked attribute path: public_network_access_enabled
# Expected: FAIL because public_network_access_enabled is explicitly true.

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg_fail_databricks_b2" {
  name     = "rg-fail-databricks-b2"
  location = "eastus"
}

resource "azurerm_databricks_workspace" "fail_databricks_b2" {
  name                          = "dbwfailbatchtwo"
  resource_group_name           = azurerm_resource_group.rg_fail_databricks_b2.name
  location                      = azurerm_resource_group.rg_fail_databricks_b2.location
  sku                           = "standard"
  public_network_access_enabled = true # ❌ FAIL: public network access remains enabled
}
