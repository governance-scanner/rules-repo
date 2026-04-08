# Policy: AzureSqlLtrValidator
# Resource type: azurerm_mssql_database
# Checked attribute path: long_term_retention_policy.yearly_retention
# Expected: FAIL because yearly_retention exceeds one year.

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg_fail_sql_ltr_b2" {
  name     = "rg-fail-sql-ltr-b2"
  location = "eastus"
}

resource "azurerm_mssql_server" "sql_fail_ltr_b2" {
  name                         = "sqlfailltrbatchtwo"
  resource_group_name          = azurerm_resource_group.rg_fail_sql_ltr_b2.name
  location                     = azurerm_resource_group.rg_fail_sql_ltr_b2.location
  version                      = "12.0"
  administrator_login          = "sqladminuser"
  administrator_login_password = "P@ssword1234!"
}

resource "azurerm_mssql_database" "fail_sql_ltr_b2" {
  name       = "sqldbfailltrb2"
  server_id  = azurerm_mssql_server.sql_fail_ltr_b2.id
  sku_name   = "S0"
  max_size_gb = 2

  long_term_retention_policy {
    yearly_retention = "P2Y" # ❌ FAIL: exceeds the one-year policy limit
    week_of_year     = 1
  }
}
