# Policy: AzureStorageAccountRetentionTagValidator
# Resource type: azurerm_storage_account
# Checked attribute path: tags.RetentionPeriod
# Expected: FAIL because the mandatory RetentionPeriod tag is omitted.

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg_fail_storage_tag_b2" {
  name     = "rg-fail-storage-tag-b2"
  location = "eastus"
}

resource "azurerm_storage_account" "fail_storage_tag_b2" {
  name                     = "safailretentionb2001"
  resource_group_name      = azurerm_resource_group.rg_fail_storage_tag_b2.name
  location                 = azurerm_resource_group.rg_fail_storage_tag_b2.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  # ❌ FAIL: RetentionPeriod tag is intentionally omitted
}
