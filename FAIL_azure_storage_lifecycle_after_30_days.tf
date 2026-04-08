# Policy: AzureStorageLifecyclePolicyValidator
# Resource type: azurerm_storage_management_policy
# Checked attribute path: rule.actions.base_blob.tier_to_cool_after_days_since_last_access_time_greater_than
# Expected: FAIL because the enabled rule tiers blobs after more than 30 days.

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg_fail_storage_lifecycle_b2" {
  name     = "rg-fail-storage-life-b2"
  location = "eastus"
}

resource "azurerm_storage_account" "sa_fail_storage_lifecycle_b2" {
  name                     = "safaillifecycleb2001"
  resource_group_name      = azurerm_resource_group.rg_fail_storage_lifecycle_b2.name
  location                 = azurerm_resource_group.rg_fail_storage_lifecycle_b2.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"

  blob_properties {
    last_access_time_enabled = true
  }
}

resource "azurerm_storage_management_policy" "fail_storage_lifecycle_b2" {
  storage_account_id = azurerm_storage_account.sa_fail_storage_lifecycle_b2.id

  rule {
    name    = "tier-slow"
    enabled = true

    filters {
      blob_types   = ["blockBlob"]
      prefix_match = ["logs"]
    }

    actions {
      base_blob {
        tier_to_cool_after_days_since_last_access_time_greater_than = 45 # ❌ FAIL: exceeds 30-day threshold
      }
    }
  }
}
