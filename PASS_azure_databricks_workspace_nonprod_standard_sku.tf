# Policy: AzureDatabricksWorkspaceSkuValidator
# Resource type: azurerm_databricks_workspace
# Checked attribute path: sku
# Expected: PASS because the non-production workspace uses Standard.

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg_pass_databricks_sku_b3" {
  name     = "rg-pass-databricks-sku-b3"
  location = "eastus"
}

resource "azurerm_databricks_workspace" "pass_databricks_sku_b3" {
  name                         = "dbwpassskubatchthree"
  resource_group_name          = azurerm_resource_group.rg_pass_databricks_sku_b3.name
  location                     = azurerm_resource_group.rg_pass_databricks_sku_b3.location
  sku                          = "standard" # ✅ PASS: allowlisted non-production SKU
  network_security_group_rules_required = "NoAzureDatabricksRules"
  tags = {
    environment = "dev"
  }
}
