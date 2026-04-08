# Policy: AzureDatabricksWorkspaceSkuValidator
# Resource type: azurerm_databricks_workspace
# Checked attribute path: sku
# Expected: FAIL because the non-production workspace uses Premium.

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg_fail_databricks_sku_b3" {
  name     = "rg-fail-databricks-sku-b3"
  location = "eastus"
}

resource "azurerm_databricks_workspace" "fail_databricks_sku_b3" {
  name                         = "dbwfailskubatchthree"
  resource_group_name          = azurerm_resource_group.rg_fail_databricks_sku_b3.name
  location                     = azurerm_resource_group.rg_fail_databricks_sku_b3.location
  sku                          = "premium" # ❌ FAIL: not in the non-production allowlist
  network_security_group_rules_required = "NoAzureDatabricksRules"
  tags = {
    environment = "dev"
  }
}
