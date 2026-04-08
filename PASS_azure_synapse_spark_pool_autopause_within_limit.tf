# Policy: AzureSynapseSparkPoolAutoPauseValidator
# Resource type: azurerm_synapse_spark_pool
# Checked attribute path: auto_pause.delay_in_minutes
# Expected: PASS because non-production auto-pause delay is 15 minutes.

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg_pass_syn_spark_ap_b2" {
  name     = "rg-pass-syn-spark-ap-b2"
  location = "eastus"
}

resource "azurerm_storage_account" "sa_pass_syn_spark_ap_b2" {
  name                     = "sapasssynsparkapb2"
  resource_group_name      = azurerm_resource_group.rg_pass_syn_spark_ap_b2.name
  location                 = azurerm_resource_group.rg_pass_syn_spark_ap_b2.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  is_hns_enabled           = true
}

resource "azurerm_storage_data_lake_gen2_filesystem" "fs_pass_syn_spark_ap_b2" {
  name               = "workspacefs"
  storage_account_id = azurerm_storage_account.sa_pass_syn_spark_ap_b2.id
}

resource "azurerm_synapse_workspace" "ws_pass_syn_spark_ap_b2" {
  name                                 = "synwspasssparkapb2"
  resource_group_name                  = azurerm_resource_group.rg_pass_syn_spark_ap_b2.name
  location                             = azurerm_resource_group.rg_pass_syn_spark_ap_b2.location
  storage_data_lake_gen2_filesystem_id = azurerm_storage_data_lake_gen2_filesystem.fs_pass_syn_spark_ap_b2.id
  sql_administrator_login              = "sqladminuser"
  sql_administrator_login_password     = "P@ssword1234!"

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_synapse_spark_pool" "pass_syn_spark_ap_b2" {
  name                 = "sparkpassautopauseb2"
  synapse_workspace_id = azurerm_synapse_workspace.ws_pass_syn_spark_ap_b2.id
  node_size_family     = "None"
  node_size            = "Small"
  spark_version        = "3.3"
  cache_size           = 100
  tags = {
    environment = "dev"
  }

  auto_pause {
    enabled          = true
    delay_in_minutes = 15 # ✅ PASS: within the 30-minute threshold
  }

  auto_scale {
    min_node_count = 3
    max_node_count = 3
  }
}
