# Policy: AzureNetAppVolumeQuotaValidator
# Resource type: azurerm_netapp_volume
# Checked attribute path: storage_quota_in_gb
# Threshold source: AzureNetAppVolumeQuotaDefinitions.DEFAULT_MIN_GIB = 50, DEFAULT_MAX_GIB = 102400
# Expected result: PASS because storage_quota_in_gb stays within the allowed range.

resource "azurerm_resource_group" "rg_pass_volume_quota" {
  name     = "rg-netapp-pass-volume-quota"
  location = "eastus"
}

resource "azurerm_virtual_network" "vnet_pass_volume_quota" {
  name                = "vnet-pass-volume-quota"
  location            = azurerm_resource_group.rg_pass_volume_quota.location
  resource_group_name = azurerm_resource_group.rg_pass_volume_quota.name
  address_space       = ["10.20.0.0/16"]
}

resource "azurerm_subnet" "subnet_pass_volume_quota" {
  name                 = "snet-pass-volume-quota"
  resource_group_name  = azurerm_resource_group.rg_pass_volume_quota.name
  virtual_network_name = azurerm_virtual_network.vnet_pass_volume_quota.name
  address_prefixes     = ["10.20.1.0/24"]

  delegation {
    name = "netapp-delegation"

    service_delegation {
      name = "Microsoft.Netapp/volumes"
      actions = [
        "Microsoft.Network/networkinterfaces/*",
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
}

resource "azurerm_netapp_account" "account_pass_volume_quota" {
  name                = "netappacctpassvolumequota"
  location            = azurerm_resource_group.rg_pass_volume_quota.location
  resource_group_name = azurerm_resource_group.rg_pass_volume_quota.name
}

resource "azurerm_netapp_pool" "pool_pass_volume_quota" {
  name                = "pool-pass-volume-quota"
  location            = azurerm_resource_group.rg_pass_volume_quota.location
  resource_group_name = azurerm_resource_group.rg_pass_volume_quota.name
  account_name        = azurerm_netapp_account.account_pass_volume_quota.name
  service_level       = "Standard"
  size_in_tb          = 4
}

resource "azurerm_netapp_volume" "volume_pass_volume_quota" {
  name                = "volume-pass-volume-quota"
  location            = azurerm_resource_group.rg_pass_volume_quota.location
  resource_group_name = azurerm_resource_group.rg_pass_volume_quota.name
  account_name        = azurerm_netapp_account.account_pass_volume_quota.name
  pool_name           = azurerm_netapp_pool.pool_pass_volume_quota.name
  volume_path         = "volpassvolumequota"
  service_level       = "Standard"
  subnet_id           = azurerm_subnet.subnet_pass_volume_quota.id
  protocols           = ["NFSv4.1"]
  storage_quota_in_gb = 100 # ✅ PASS: inside the inclusive 50..102400 range

  export_policy_rule {
    rule_index        = 1
    allowed_clients   = ["0.0.0.0/0"]
    protocols_enabled = ["NFSv4.1"]
    unix_read_only    = false
    unix_read_write   = true
  }
}
