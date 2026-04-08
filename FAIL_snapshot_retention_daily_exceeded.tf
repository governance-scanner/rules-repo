# Policy: AzureNetAppSnapshotRetentionValidation
# Resource type: azurerm_netapp_snapshot_policy
# Checked attribute path: daily_schedule.*.snapshots_to_keep
# Threshold source: AzureNetAppSnapshotRetentionDefinitions.THRESHOLDS["daily_schedule"] = 30
# Expected result: FAIL because daily retention exceeds the allowed limit.

resource "azurerm_resource_group" "rg_fail_snapshot_retention_daily" {
  name     = "rg-netapp-fail-snapshot-daily"
  location = "eastus"
}

resource "azurerm_netapp_account" "account_fail_snapshot_retention_daily" {
  name                = "netappacctfailsnapshotdly"
  location            = azurerm_resource_group.rg_fail_snapshot_retention_daily.location
  resource_group_name = azurerm_resource_group.rg_fail_snapshot_retention_daily.name
}

resource "azurerm_netapp_snapshot_policy" "snapshot_policy_fail_retention_daily" {
  name                = "snapshot-policy-fail-daily"
  location            = azurerm_resource_group.rg_fail_snapshot_retention_daily.location
  resource_group_name = azurerm_resource_group.rg_fail_snapshot_retention_daily.name
  account_name        = azurerm_netapp_account.account_fail_snapshot_retention_daily.name
  enabled             = true

  daily_schedule {
    minute            = 0
    hour              = 1
    snapshots_to_keep = 31 # ❌ FAIL: above the daily threshold of 30
  }

  weekly_schedule {
    minute            = 15
    hour              = 2
    days_of_week      = ["Sunday"]
    snapshots_to_keep = 4 # ✅ Passes weekly threshold
  }

  monthly_schedule {
    minute            = 30
    hour              = 3
    days_of_month     = [1]
    snapshots_to_keep = 1 # ✅ Passes monthly threshold
  }
}
