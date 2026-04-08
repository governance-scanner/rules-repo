# Policy: AzureSynapseSparkPoolAutoscaleThresholdValidator
# Resource type: azurerm_synapse_spark_pool
# Checked attribute path: auto_scale.min_node_count / auto_scale.max_node_count
# Expected: PASS because auto_scale is present and stays within min 3 / max 10.

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg_pass_synapse_autoscale_b4" {
  name     = "rg-pass-syn-autoscale-b4"
  location = "eastus"
}

resource "azurerm_storage_account" "sa_pass_synapse_autoscale_b4" {
  name                     = "sapasssynautoscaleb4"
  resource_group_name      = azurerm_resource_group.rg_pass_synapse_autoscale_b4.name
  location                 = azurerm_resource_group.rg_pass_synapse_autoscale_b4.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  is_hns_enabled           = true
}

resource "azurerm_storage_data_lake_gen2_filesystem" "fs_pass_synapse_autoscale_b4" {
  name               = "workspacefs"
  storage_account_id = azurerm_storage_account.sa_pass_synapse_autoscale_b4.id
}

resource "azurerm_synapse_workspace" "ws_pass_synapse_autoscale_b4" {
  name                                 = "synwspassautoscaleb4"
  resource_group_name                  = azurerm_resource_group.rg_pass_synapse_autoscale_b4.name
  location                             = azurerm_resource_group.rg_pass_synapse_autoscale_b4.location
  storage_data_lake_gen2_filesystem_id = azurerm_storage_data_lake_gen2_filesystem.fs_pass_synapse_autoscale_b4.id
  sql_administrator_login              = "sqladminuser"
  sql_administrator_login_password     = "P@ssword1234!"

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_synapse_spark_pool" "pass_synapse_autoscale_b4" {
  name                 = "sparkpassautoscaleb4"
  synapse_workspace_id = azurerm_synapse_workspace.ws_pass_synapse_autoscale_b4.id
  node_size_family     = "None"
  node_size            = "Small"
  spark_version        = "3.3"
  cache_size           = 100

  auto_scale {
    min_node_count = 3 # ✅ PASS: meets the minimum threshold
    max_node_count = 10 # ✅ PASS: meets the maximum threshold
  }
}
