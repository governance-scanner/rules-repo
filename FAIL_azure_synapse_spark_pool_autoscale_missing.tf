# Policy: AzureSynapseSparkPoolAutoscaleThresholdValidator
# Resource type: azurerm_synapse_spark_pool
# Checked attribute path: auto_scale
# Expected: FAIL because the auto_scale block is omitted entirely.

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg_fail_synapse_autoscale_missing_b4" {
  name     = "rg-fail-syn-autoscale-m-b4"
  location = "eastus"
}

resource "azurerm_storage_account" "sa_fail_synapse_autoscale_missing_b4" {
  name                     = "safailsynautoscmissb4"
  resource_group_name      = azurerm_resource_group.rg_fail_synapse_autoscale_missing_b4.name
  location                 = azurerm_resource_group.rg_fail_synapse_autoscale_missing_b4.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  is_hns_enabled           = true
}

resource "azurerm_storage_data_lake_gen2_filesystem" "fs_fail_synapse_autoscale_missing_b4" {
  name               = "workspacefs"
  storage_account_id = azurerm_storage_account.sa_fail_synapse_autoscale_missing_b4.id
}

resource "azurerm_synapse_workspace" "ws_fail_synapse_autoscale_missing_b4" {
  name                                 = "synwsfailautoscmissb4"
  resource_group_name                  = azurerm_resource_group.rg_fail_synapse_autoscale_missing_b4.name
  location                             = azurerm_resource_group.rg_fail_synapse_autoscale_missing_b4.location
  storage_data_lake_gen2_filesystem_id = azurerm_storage_data_lake_gen2_filesystem.fs_fail_synapse_autoscale_missing_b4.id
  sql_administrator_login              = "sqladminuser"
  sql_administrator_login_password     = "P@ssword1234!"

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_synapse_spark_pool" "fail_synapse_autoscale_missing_b4" {
  name                 = "sparkfailautoscmissb4"
  synapse_workspace_id = azurerm_synapse_workspace.ws_fail_synapse_autoscale_missing_b4.id
  node_size_family     = "None"
  node_size            = "Small"
  node_count           = 3 # ✅ provider-valid fixed-size pool, but no auto_scale block
  spark_version        = "3.3"
  cache_size           = 100
  # ❌ FAIL: auto_scale block is intentionally omitted
}
