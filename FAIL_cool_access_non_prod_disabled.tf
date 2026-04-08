# Policy: AzureNetAppCoolAccessValidator
# Resource type: azurerm_netapp_volume
# Doc-aligned resource shape: cool access is configured at the volume level via a cool_access block, and the pool must support cool access.
# Expected by latest docs: FAIL because the volume omits the cool_access block even though the pool supports cool access.
# Scanner risk: the current policy still checks the legacy-looking key cool_access_enabled on the volume.

resource "azurerm_resource_group" "rg_fail_cool_access" {
  name     = "rg-netapp-fail-cool-access"
  location = "eastus"
}

resource "azurerm_virtual_network" "vnet_fail_cool_access" {
  name                = "vnet-fail-cool-access"
  location            = azurerm_resource_group.rg_fail_cool_access.location
  resource_group_name = azurerm_resource_group.rg_fail_cool_access.name
  address_space       = ["10.24.0.0/16"]
}

resource "azurerm_subnet" "subnet_fail_cool_access" {
  name                 = "snet-fail-cool-access"
  resource_group_name  = azurerm_resource_group.rg_fail_cool_access.name
  virtual_network_name = azurerm_virtual_network.vnet_fail_cool_access.name
  address_prefixes     = ["10.24.1.0/24"]

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

resource "azurerm_netapp_account" "account_fail_cool_access" {
  name                = "netappacctfailcoolaccess"
  location            = azurerm_resource_group.rg_fail_cool_access.location
  resource_group_name = azurerm_resource_group.rg_fail_cool_access.name
}

resource "azurerm_netapp_pool" "pool_fail_cool_access" {
  name                = "pool-fail-cool-access"
  location            = azurerm_resource_group.rg_fail_cool_access.location
  resource_group_name = azurerm_resource_group.rg_fail_cool_access.name
  account_name        = azurerm_netapp_account.account_fail_cool_access.name
  service_level       = "Standard"
  size_in_tb          = 4
  cool_access_enabled = true # ✅ Passes pool capability requirement for cool-access-enabled volumes
}

resource "azurerm_netapp_volume" "volume_fail_cool_access" {
  name                = "volume-fail-cool-access"
  location            = azurerm_resource_group.rg_fail_cool_access.location
  resource_group_name = azurerm_resource_group.rg_fail_cool_access.name
  account_name        = azurerm_netapp_account.account_fail_cool_access.name
  pool_name           = azurerm_netapp_pool.pool_fail_cool_access.name
  volume_path         = "volfailcoolaccess"
  service_level       = "Standard"
  subnet_id           = azurerm_subnet.subnet_fail_cool_access.id
  protocols           = ["NFSv4.1"]
  storage_quota_in_gb = 100
  tags = {
    environment = "dev"
  }
  # ❌ FAIL: cool_access block omitted, so cool access is not enabled on the volume

  export_policy_rule {
    rule_index        = 1
    allowed_clients   = ["0.0.0.0/0"]
    protocols_enabled = ["NFSv4.1"]
    unix_read_only    = false
    unix_read_write   = true
  }
}
