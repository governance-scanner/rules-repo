# Policy: AzureSynapseSparkPoolNodeCountValidator
# Resource type: azurerm_synapse_spark_pool
# Checked attribute paths: node_count and auto_scale.max_node_count
# Expected: PASS because the fixed node_count is within the limit of 10.

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg_pass_synapse_node_count_b4" {
  name     = "rg-pass-syn-nodecount-b4"
  location = "eastus"
}

resource "azurerm_storage_account" "sa_pass_synapse_node_count_b4" {
  name                     = "sapasssynnodecountb4"
  resource_group_name      = azurerm_resource_group.rg_pass_synapse_node_count_b4.name
  location                 = azurerm_resource_group.rg_pass_synapse_node_count_b4.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  is_hns_enabled           = true
}

resource "azurerm_storage_data_lake_gen2_filesystem" "fs_pass_synapse_node_count_b4" {
  name               = "workspacefs"
  storage_account_id = azurerm_storage_account.sa_pass_synapse_node_count_b4.id
}

resource "azurerm_synapse_workspace" "ws_pass_synapse_node_count_b4" {
  name                                 = "synwspassnodecountb4"
  resource_group_name                  = azurerm_resource_group.rg_pass_synapse_node_count_b4.name
  location                             = azurerm_resource_group.rg_pass_synapse_node_count_b4.location
  storage_data_lake_gen2_filesystem_id = azurerm_storage_data_lake_gen2_filesystem.fs_pass_synapse_node_count_b4.id
  sql_administrator_login              = "sqladminuser"
  sql_administrator_login_password     = "P@ssword1234!"

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_synapse_spark_pool" "pass_synapse_node_count_b4" {
  name                 = "sparkpassnodecountb4"
  synapse_workspace_id = azurerm_synapse_workspace.ws_pass_synapse_node_count_b4.id
  node_size_family     = "None"
  node_size            = "Small"
  node_count           = 5 # ✅ PASS: within the node count limit
  spark_version        = "3.3"
  cache_size           = 100
}
