# Policy: AzureStorageAccountRetentionTagValidator
# Resource type: azurerm_storage_account
# Checked attribute path: tags.RetentionPeriod
# Expected: PASS because the mandatory RetentionPeriod tag is present.

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg_pass_storage_tag_b2" {
  name     = "rg-pass-storage-tag-b2"
  location = "eastus"
}

resource "azurerm_storage_account" "pass_storage_tag_b2" {
  name                     = "sapassretentionb2001"
  resource_group_name      = azurerm_resource_group.rg_pass_storage_tag_b2.name
  location                 = azurerm_resource_group.rg_pass_storage_tag_b2.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags = {
    RetentionPeriod = "365" # ✅ PASS: mandatory retention tag is present
  }
}
