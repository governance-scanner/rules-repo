# Policy: AzureNetAppSnapshotRetentionValidation
# Resource type: azurerm_netapp_snapshot_policy
# Checked attribute path: weekly_schedule.*.snapshots_to_keep
# Threshold source: AzureNetAppSnapshotRetentionDefinitions.THRESHOLDS["weekly_schedule"] = 4
# Expected result: FAIL because weekly retention exceeds the allowed limit.

resource "azurerm_resource_group" "rg_fail_snapshot_retention_weekly" {
  name     = "rg-netapp-fail-snapshot-weekly"
  location = "eastus"
}

resource "azurerm_netapp_account" "account_fail_snapshot_retention_weekly" {
  name                = "netappacctfailsnapshotwky"
  location            = azurerm_resource_group.rg_fail_snapshot_retention_weekly.location
  resource_group_name = azurerm_resource_group.rg_fail_snapshot_retention_weekly.name
}

resource "azurerm_netapp_snapshot_policy" "snapshot_policy_fail_retention_weekly" {
  name                = "snapshot-policy-fail-weekly"
  location            = azurerm_resource_group.rg_fail_snapshot_retention_weekly.location
  resource_group_name = azurerm_resource_group.rg_fail_snapshot_retention_weekly.name
  account_name        = azurerm_netapp_account.account_fail_snapshot_retention_weekly.name
  enabled             = true

  daily_schedule {
    minute            = 0
    hour              = 1
    snapshots_to_keep = 30 # ✅ Passes daily threshold
  }

  weekly_schedule {
    minute            = 15
    hour              = 2
    days_of_week      = ["Sunday"]
    snapshots_to_keep = 5 # ❌ FAIL: above the weekly threshold of 4
  }

  monthly_schedule {
    minute            = 30
    hour              = 3
    days_of_month     = [1]
    snapshots_to_keep = 1 # ✅ Passes monthly threshold
  }
}
