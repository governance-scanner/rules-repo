# Policy: AzureSynapseSparkPoolNodeCountValidator
# Resource type: azurerm_synapse_spark_pool
# Checked attribute path: auto_scale.max_node_count
# Expected: FAIL because auto_scale.max_node_count exceeds 10.

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg_fail_synapse_auto_node_count_b4" {
  name     = "rg-fail-syn-autonode-b4"
  location = "eastus"
}

resource "azurerm_storage_account" "sa_fail_synapse_auto_node_count_b4" {
  name                     = "safailsynautonodeb4"
  resource_group_name      = azurerm_resource_group.rg_fail_synapse_auto_node_count_b4.name
  location                 = azurerm_resource_group.rg_fail_synapse_auto_node_count_b4.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  is_hns_enabled           = true
}

resource "azurerm_storage_data_lake_gen2_filesystem" "fs_fail_synapse_auto_node_count_b4" {
  name               = "workspacefs"
  storage_account_id = azurerm_storage_account.sa_fail_synapse_auto_node_count_b4.id
}

resource "azurerm_synapse_workspace" "ws_fail_synapse_auto_node_count_b4" {
  name                                 = "synwsfailautonodeb4"
  resource_group_name                  = azurerm_resource_group.rg_fail_synapse_auto_node_count_b4.name
  location                             = azurerm_resource_group.rg_fail_synapse_auto_node_count_b4.location
  storage_data_lake_gen2_filesystem_id = azurerm_storage_data_lake_gen2_filesystem.fs_fail_synapse_auto_node_count_b4.id
  sql_administrator_login              = "sqladminuser"
  sql_administrator_login_password     = "P@ssword1234!"

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_synapse_spark_pool" "fail_synapse_auto_node_count_b4" {
  name                 = "sparkfailautonodeb4"
  synapse_workspace_id = azurerm_synapse_workspace.ws_fail_synapse_auto_node_count_b4.id
  node_size_family     = "None"
  node_size            = "Small"
  spark_version        = "3.3"
  cache_size           = 100

  auto_scale {
    min_node_count = 3
    max_node_count = 12 # ❌ FAIL: exceeds the node count limit via autoscale
  }
}
