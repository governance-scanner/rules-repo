# Policy: AzureManagedDiskTTLTagValidator
# Resource type: azurerm_managed_disk
# Checked attribute path: tags[ttl-like-key]
# Expected: PASS because a non-production disk has a TTL tag.

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg_pass_managed_disk_ttl" {
  name     = "rg-pass-managed-disk-ttl"
  location = "eastus"
}

resource "azurerm_managed_disk" "pass_managed_disk_ttl" {
  name                 = "mdpassnonprodttl"
  location             = azurerm_resource_group.rg_pass_managed_disk_ttl.location
  resource_group_name  = azurerm_resource_group.rg_pass_managed_disk_ttl.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 4
  tags = {
    environment = "dev"
    ttl         = "2026-12-31" # ✅ PASS: TTL tag present with a recognized key
  }
}
