# Policy: AzureSynapseSQLPoolDWUValidator
# Resource type: azurerm_synapse_sql_pool
# Checked attribute path: sku_name
# Expected: FAIL because DW500c exceeds the non-production threshold of 300.

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg_fail_syn_sql_b2" {
  name     = "rg-fail-syn-sql-b2"
  location = "eastus"
}

resource "azurerm_storage_account" "sa_fail_syn_sql_b2" {
  name                     = "safailsynsqlpoolb2"
  resource_group_name      = azurerm_resource_group.rg_fail_syn_sql_b2.name
  location                 = azurerm_resource_group.rg_fail_syn_sql_b2.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  is_hns_enabled           = true
}

resource "azurerm_storage_data_lake_gen2_filesystem" "fs_fail_syn_sql_b2" {
  name               = "workspacefs"
  storage_account_id = azurerm_storage_account.sa_fail_syn_sql_b2.id
}

resource "azurerm_synapse_workspace" "ws_fail_syn_sql_b2" {
  name                                 = "synwsfailsqlpoolb2"
  resource_group_name                  = azurerm_resource_group.rg_fail_syn_sql_b2.name
  location                             = azurerm_resource_group.rg_fail_syn_sql_b2.location
  storage_data_lake_gen2_filesystem_id = azurerm_storage_data_lake_gen2_filesystem.fs_fail_syn_sql_b2.id
  sql_administrator_login              = "sqladminuser"
  sql_administrator_login_password     = "P@ssword1234!"

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_synapse_sql_pool" "fail_syn_sql_b2" {
  name                 = "sqlpoolfaildwu500b2"
  synapse_workspace_id = azurerm_synapse_workspace.ws_fail_syn_sql_b2.id
  sku_name             = "DW500c" # ❌ FAIL: exceeds the allowed maximum DWU threshold
  create_mode          = "Default"
  tags = {
    environment = "dev"
  }
}
