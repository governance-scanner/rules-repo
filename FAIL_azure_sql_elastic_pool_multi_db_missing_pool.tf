# Policy: AzureSqlElasticPoolValidator
# Resource type: azurerm_mssql_database
# Checked attribute path: elastic_pool_id
# Expected: FAIL because multiple databases exist in the same file and one omits elastic_pool_id.

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg_fail_sql_pool_b2" {
  name     = "rg-fail-sql-pool-b2"
  location = "eastus"
}

resource "azurerm_mssql_server" "sql_fail_pool_b2" {
  name                         = "sqlfailpoolbatchtwo"
  resource_group_name          = azurerm_resource_group.rg_fail_sql_pool_b2.name
  location                     = azurerm_resource_group.rg_fail_sql_pool_b2.location
  version                      = "12.0"
  administrator_login          = "sqladminuser"
  administrator_login_password = "P@ssword1234!"
}

resource "azurerm_mssql_database" "fail_sql_pool_primary_b2" {
  name       = "sqldbpoolfail1b2"
  server_id  = azurerm_mssql_server.sql_fail_pool_b2.id
  sku_name   = "S0"
  max_size_gb = 2
  # ❌ FAIL: elastic_pool_id omitted while another database exists in the same file
}

resource "azurerm_mssql_database" "fail_sql_pool_secondary_b2" {
  name       = "sqldbpoolfail2b2"
  server_id  = azurerm_mssql_server.sql_fail_pool_b2.id
  sku_name   = "S0"
  max_size_gb = 2
}
