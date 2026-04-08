# Policy: AzureSynapseSparkPoolAutoPauseValidator
# Resource type: azurerm_synapse_spark_pool
# Checked attribute path: auto_pause.delay_in_minutes
# Expected: FAIL because non-production auto-pause delay exceeds 30 minutes.

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg_fail_syn_spark_ap_b2" {
  name     = "rg-fail-syn-spark-ap-b2"
  location = "eastus"
}

resource "azurerm_storage_account" "sa_fail_syn_spark_ap_b2" {
  name                     = "safailsynsparkapb2"
  resource_group_name      = azurerm_resource_group.rg_fail_syn_spark_ap_b2.name
  location                 = azurerm_resource_group.rg_fail_syn_spark_ap_b2.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  is_hns_enabled           = true
}

resource "azurerm_storage_data_lake_gen2_filesystem" "fs_fail_syn_spark_ap_b2" {
  name               = "workspacefs"
  storage_account_id = azurerm_storage_account.sa_fail_syn_spark_ap_b2.id
}

resource "azurerm_synapse_workspace" "ws_fail_syn_spark_ap_b2" {
  name                                 = "synwsfailsparkapb2"
  resource_group_name                  = azurerm_resource_group.rg_fail_syn_spark_ap_b2.name
  location                             = azurerm_resource_group.rg_fail_syn_spark_ap_b2.location
  storage_data_lake_gen2_filesystem_id = azurerm_storage_data_lake_gen2_filesystem.fs_fail_syn_spark_ap_b2.id
  sql_administrator_login              = "sqladminuser"
  sql_administrator_login_password     = "P@ssword1234!"

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_synapse_spark_pool" "fail_syn_spark_ap_b2" {
  name                 = "sparkfailautopauseb2"
  synapse_workspace_id = azurerm_synapse_workspace.ws_fail_syn_spark_ap_b2.id
  node_size_family     = "None"
  node_size            = "Small"
  spark_version        = "3.3"
  cache_size           = 100
  tags = {
    environment = "dev"
  }

  auto_pause {
    enabled          = true # ✅ Passes expected service shape; scanner currently ignores this flag
    delay_in_minutes = 45   # ❌ FAIL: exceeds the 30-minute threshold
  }

  auto_scale {
    min_node_count = 3
    max_node_count = 3
  }
}
