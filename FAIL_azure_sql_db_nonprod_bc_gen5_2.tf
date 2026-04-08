# Policy: AzureSqlDbTierValidator
# Resource type: azurerm_mssql_database
# Checked attribute path: sku_name
# Expected: FAIL because non-production uses a Business Critical tier.

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg_fail_sql_tier_b2" {
  name     = "rg-fail-sql-tier-b2"
  location = "eastus"
}

resource "azurerm_mssql_server" "sql_fail_tier_b2" {
  name                         = "sqlfailtierbatchtwo"
  resource_group_name          = azurerm_resource_group.rg_fail_sql_tier_b2.name
  location                     = azurerm_resource_group.rg_fail_sql_tier_b2.location
  version                      = "12.0"
  administrator_login          = "sqladminuser"
  administrator_login_password = "P@ssword1234!"
}

resource "azurerm_mssql_database" "fail_sql_tier_b2" {
  name       = "sqldbfailtierb2"
  server_id  = azurerm_mssql_server.sql_fail_tier_b2.id
  sku_name   = "BC_Gen5_2" # ❌ FAIL: does not contain Basic, S, or GP_
  max_size_gb = 2
  tags = {
    environment = "dev"
  }
}
