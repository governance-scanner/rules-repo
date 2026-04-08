# Policy: AzureMSSQLDatabaseEnvironmentValidator
# Resource type: azurerm_mssql_database
# Checked attribute paths: tags.environment, elastic_pool_id, sku_name, auto_pause_delay_in_minutes
# Expected: PASS because the database is tagged production, so the non-production checks do not apply.

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg_pass_mssql_env_b2" {
  name     = "rg-pass-mssql-env-b2"
  location = "eastus"
}

resource "azurerm_mssql_server" "sql_pass_mssql_env_b2" {
  name                         = "sqlpassenvbatchtwo"
  resource_group_name          = azurerm_resource_group.rg_pass_mssql_env_b2.name
  location                     = azurerm_resource_group.rg_pass_mssql_env_b2.location
  version                      = "12.0"
  administrator_login          = "sqladminuser"
  administrator_login_password = "P@ssword1234!"
}

resource "azurerm_mssql_database" "pass_mssql_env_b2" {
  name      = "sqldbpassenvb2"
  server_id = azurerm_mssql_server.sql_pass_mssql_env_b2.id
  sku_name  = "S0"
  max_size_gb = 2
  tags = {
    environment = "production" # ✅ PASS: production resources are out of scope for this validator
  }
}
