# Policy: AzureSqlElasticPoolValidator
# Resource type: azurerm_mssql_database
# Checked attribute path: elastic_pool_id
# Expected: PASS because only one database exists in this file, so the multi-database elastic pool rule does not apply.

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg_pass_sql_pool_b2" {
  name     = "rg-pass-sql-pool-b2"
  location = "eastus"
}

resource "azurerm_mssql_server" "sql_pass_pool_b2" {
  name                         = "sqlpasspoolbatchtwo"
  resource_group_name          = azurerm_resource_group.rg_pass_sql_pool_b2.name
  location                     = azurerm_resource_group.rg_pass_sql_pool_b2.location
  version                      = "12.0"
  administrator_login          = "sqladminuser"
  administrator_login_password = "P@ssword1234!"
}

resource "azurerm_mssql_database" "pass_sql_pool_b2" {
  name       = "sqldbpasspoolb2"
  server_id  = azurerm_mssql_server.sql_pass_pool_b2.id
  sku_name   = "S0"
  max_size_gb = 2
}
