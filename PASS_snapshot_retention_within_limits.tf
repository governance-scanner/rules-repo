# Policy: AzureNetAppSnapshotRetentionValidation
# Resource type: azurerm_netapp_snapshot_policy
# Checked attribute path: <schedule>.*.snapshots_to_keep
# Threshold source: AzureNetAppSnapshotRetentionDefinitions.THRESHOLDS
# Expected result: PASS because daily <= 30, weekly <= 4, monthly <= 1.

resource "azurerm_resource_group" "rg_pass_snapshot_retention" {
  name     = "rg-netapp-pass-snapshot-retention"
  location = "eastus"
}

resource "azurerm_netapp_account" "account_pass_snapshot_retention" {
  name                = "netappacctpasssnapshotret"
  location            = azurerm_resource_group.rg_pass_snapshot_retention.location
  resource_group_name = azurerm_resource_group.rg_pass_snapshot_retention.name
}

resource "azurerm_netapp_snapshot_policy" "snapshot_policy_pass_retention" {
  name                = "snapshot-policy-pass-retention"
  location            = azurerm_resource_group.rg_pass_snapshot_retention.location
  resource_group_name = azurerm_resource_group.rg_pass_snapshot_retention.name
  account_name        = azurerm_netapp_account.account_pass_snapshot_retention.name
  enabled             = true

  daily_schedule {
    minute            = 0
    hour              = 1
    snapshots_to_keep = 30 # ✅ PASS: matches the daily threshold exactly
  }

  weekly_schedule {
    minute            = 15
    hour              = 2
    days_of_week      = ["Sunday"]
    snapshots_to_keep = 4 # ✅ PASS: matches the weekly threshold exactly
  }

  monthly_schedule {
    minute            = 30
    hour              = 3
    days_of_month     = [1]
    snapshots_to_keep = 1 # ✅ PASS: matches the monthly threshold exactly
  }
}
