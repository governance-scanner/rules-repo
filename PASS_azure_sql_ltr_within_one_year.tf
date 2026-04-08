# Policy: AzureSqlLtrValidator
# Resource type: azurerm_mssql_database
# Checked attribute path: long_term_retention_policy.yearly_retention
# Expected: PASS because yearly_retention stays within one year.

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg_pass_sql_ltr_b2" {
  name     = "rg-pass-sql-ltr-b2"
  location = "eastus"
}

resource "azurerm_mssql_server" "sql_pass_ltr_b2" {
  name                         = "sqlpassltrbatchtwo"
  resource_group_name          = azurerm_resource_group.rg_pass_sql_ltr_b2.name
  location                     = azurerm_resource_group.rg_pass_sql_ltr_b2.location
  version                      = "12.0"
  administrator_login          = "sqladminuser"
  administrator_login_password = "P@ssword1234!"
}

resource "azurerm_mssql_database" "pass_sql_ltr_b2" {
  name       = "sqldbpassltrb2"
  server_id  = azurerm_mssql_server.sql_pass_ltr_b2.id
  sku_name   = "S0"
  max_size_gb = 2

  long_term_retention_policy {
    yearly_retention = "P1Y" # ✅ PASS: within the one-year limit
    week_of_year     = 1
  }
}
