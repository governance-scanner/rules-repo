# Policy: AzureMSSQLDatabaseEnvironmentValidator
# Resource type: azurerm_mssql_database
# Checked attribute paths: tags.environment, elastic_pool_id, sku_name, auto_pause_delay_in_minutes
# Expected: FAIL because a non-production database is created without elastic_pool_id.

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg_fail_mssql_env_b2" {
  name     = "rg-fail-mssql-env-b2"
  location = "eastus"
}

resource "azurerm_mssql_server" "sql_fail_mssql_env_b2" {
  name                         = "sqlfailenvbatchtwo"
  resource_group_name          = azurerm_resource_group.rg_fail_mssql_env_b2.name
  location                     = azurerm_resource_group.rg_fail_mssql_env_b2.location
  version                      = "12.0"
  administrator_login          = "sqladminuser"
  administrator_login_password = "P@ssword1234!"
}

resource "azurerm_mssql_database" "fail_mssql_env_b2" {
  name       = "sqldbfailenvb2"
  server_id  = azurerm_mssql_server.sql_fail_mssql_env_b2.id
  sku_name   = "S0" # ✅ Passes serverless branch precondition because this is not a serverless SKU
  max_size_gb = 2
  tags = {
    environment = "dev" # ✅ Passes environment gate and proceeds to elastic pool check
  }
  # ❌ FAIL: elastic_pool_id is intentionally omitted
}
