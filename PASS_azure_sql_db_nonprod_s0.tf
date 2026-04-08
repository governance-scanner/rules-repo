# Policy: AzureSqlDbTierValidator
# Resource type: azurerm_mssql_database
# Checked attribute path: sku_name
# Expected: PASS because non-production uses S0, which matches the allowlist fragments.

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg_pass_sql_tier_b2" {
  name     = "rg-pass-sql-tier-b2"
  location = "eastus"
}

resource "azurerm_mssql_server" "sql_pass_tier_b2" {
  name                         = "sqlpasstierbatchtwo"
  resource_group_name          = azurerm_resource_group.rg_pass_sql_tier_b2.name
  location                     = azurerm_resource_group.rg_pass_sql_tier_b2.location
  version                      = "12.0"
  administrator_login          = "sqladminuser"
  administrator_login_password = "P@ssword1234!"
}

resource "azurerm_mssql_database" "pass_sql_tier_b2" {
  name       = "sqldbpasstierb2"
  server_id  = azurerm_mssql_server.sql_pass_tier_b2.id
  sku_name   = "S0" # ✅ PASS: matches allowlist fragment S
  max_size_gb = 2
  tags = {
    environment = "dev"
  }
}
