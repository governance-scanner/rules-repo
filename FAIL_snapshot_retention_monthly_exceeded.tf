# Policy: AzureNetAppSnapshotRetentionValidation
# Resource type: azurerm_netapp_snapshot_policy
# Checked attribute path: monthly_schedule.*.snapshots_to_keep
# Threshold source: AzureNetAppSnapshotRetentionDefinitions.THRESHOLDS["monthly_schedule"] = 1
# Expected result: FAIL because monthly retention exceeds the allowed limit.

resource "azurerm_resource_group" "rg_fail_snapshot_retention_monthly" {
  name     = "rg-netapp-fail-snapshot-monthly"
  location = "eastus"
}

resource "azurerm_netapp_account" "account_fail_snapshot_retention_monthly" {
  name                = "netappacctfailsnapshotmly"
  location            = azurerm_resource_group.rg_fail_snapshot_retention_monthly.location
  resource_group_name = azurerm_resource_group.rg_fail_snapshot_retention_monthly.name
}

resource "azurerm_netapp_snapshot_policy" "snapshot_policy_fail_retention_monthly" {
  name                = "snapshot-policy-fail-monthly"
  location            = azurerm_resource_group.rg_fail_snapshot_retention_monthly.location
  resource_group_name = azurerm_resource_group.rg_fail_snapshot_retention_monthly.name
  account_name        = azurerm_netapp_account.account_fail_snapshot_retention_monthly.name
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
    snapshots_to_keep = 4 # ✅ Passes weekly threshold
  }

  monthly_schedule {
    minute            = 30
    hour              = 3
    days_of_month     = [1]
    snapshots_to_keep = 2 # ❌ FAIL: above the monthly threshold of 1
  }
}
