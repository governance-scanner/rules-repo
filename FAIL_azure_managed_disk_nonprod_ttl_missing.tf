# Policy: AzureManagedDiskTTLTagValidator
# Resource type: azurerm_managed_disk
# Checked attribute path: tags[ttl-like-key]
# Expected: FAIL because a non-production disk has no TTL tag.

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg_fail_managed_disk_ttl" {
  name     = "rg-fail-managed-disk-ttl"
  location = "eastus"
}

resource "azurerm_managed_disk" "fail_managed_disk_ttl" {
  name                 = "mdfailnonprodttl"
  location             = azurerm_resource_group.rg_fail_managed_disk_ttl.location
  resource_group_name  = azurerm_resource_group.rg_fail_managed_disk_ttl.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 4
  tags = {
    environment = "dev"
    owner       = "platform-team"
  }
  # ❌ FAIL: no TTL/time_to_live/timetolive/expiry/delete_after tag present
}
