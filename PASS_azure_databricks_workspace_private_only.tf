# Policy: AzureDatabricksWorkspacePublicAccessValidator
# Resource type: azurerm_databricks_workspace
# Checked attribute path: public_network_access_enabled
# Expected: PASS because public_network_access_enabled is explicitly false.

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg_pass_databricks_b2" {
  name     = "rg-pass-databricks-b2"
  location = "eastus"
}

resource "azurerm_databricks_workspace" "pass_databricks_b2" {
  name                                  = "dbwpassbatchtwo"
  resource_group_name                   = azurerm_resource_group.rg_pass_databricks_b2.name
  location                              = azurerm_resource_group.rg_pass_databricks_b2.location
  sku                                   = "standard"
  public_network_access_enabled         = false # ✅ PASS: explicitly disables public network access
  network_security_group_rules_required = "NoAzureDatabricksRules"
}
