# Policy: AzureSynapseSparkPoolNodeSizeValidator
# Resource type: azurerm_synapse_spark_pool
# Checked attribute paths: node_size, node_size_family
# Expected: FAIL because non-production uses the denied MemoryOptimized family.

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg_fail_syn_spark_size_mem_b2" {
  name     = "rg-fail-syn-size-mem-b2"
  location = "eastus"
}

resource "azurerm_storage_account" "sa_fail_syn_spark_size_mem_b2" {
  name                     = "safailsynsizememb2"
  resource_group_name      = azurerm_resource_group.rg_fail_syn_spark_size_mem_b2.name
  location                 = azurerm_resource_group.rg_fail_syn_spark_size_mem_b2.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  is_hns_enabled           = true
}

resource "azurerm_storage_data_lake_gen2_filesystem" "fs_fail_syn_spark_size_mem_b2" {
  name               = "workspacefs"
  storage_account_id = azurerm_storage_account.sa_fail_syn_spark_size_mem_b2.id
}

resource "azurerm_synapse_workspace" "ws_fail_syn_spark_size_mem_b2" {
  name                                 = "synwsfailsizememb2"
  resource_group_name                  = azurerm_resource_group.rg_fail_syn_spark_size_mem_b2.name
  location                             = azurerm_resource_group.rg_fail_syn_spark_size_mem_b2.location
  storage_data_lake_gen2_filesystem_id = azurerm_storage_data_lake_gen2_filesystem.fs_fail_syn_spark_size_mem_b2.id
  sql_administrator_login              = "sqladminuser"
  sql_administrator_login_password     = "P@ssword1234!"

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_synapse_spark_pool" "fail_syn_spark_size_mem_b2" {
  name                 = "sparkfailsizememb2"
  synapse_workspace_id = azurerm_synapse_workspace.ws_fail_syn_spark_size_mem_b2.id
  node_size_family     = "MemoryOptimized" # ❌ FAIL: denied family
  node_size            = "Medium"          # ✅ Passes size allowlist before family check
  spark_version        = "3.3"
  cache_size           = 100
  tags = {
    environment = "dev"
  }
}
