# Policy: AzureNetAppCoolAccessValidator
# Resource type: azurerm_netapp_volume
# Doc-aligned resource shape: cool access is configured at the volume level via a cool_access block, and the pool must support cool access.
# Expected by latest docs: PASS because cool access is enabled on the volume and the containing pool allows cool access.
# Scanner risk: the current policy still checks the legacy-looking key cool_access_enabled on the volume.

resource "azurerm_resource_group" "rg_pass_cool_access" {
  name     = "rg-netapp-pass-cool-access"
  location = "eastus"
}

resource "azurerm_virtual_network" "vnet_pass_cool_access" {
  name                = "vnet-pass-cool-access"
  location            = azurerm_resource_group.rg_pass_cool_access.location
  resource_group_name = azurerm_resource_group.rg_pass_cool_access.name
  address_space       = ["10.23.0.0/16"]
}

resource "azurerm_subnet" "subnet_pass_cool_access" {
  name                 = "snet-pass-cool-access"
  resource_group_name  = azurerm_resource_group.rg_pass_cool_access.name
  virtual_network_name = azurerm_virtual_network.vnet_pass_cool_access.name
  address_prefixes     = ["10.23.1.0/24"]

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

resource "azurerm_netapp_account" "account_pass_cool_access" {
  name                = "netappacctpasscoolaccess"
  location            = azurerm_resource_group.rg_pass_cool_access.location
  resource_group_name = azurerm_resource_group.rg_pass_cool_access.name
}

resource "azurerm_netapp_pool" "pool_pass_cool_access" {
  name                = "pool-pass-cool-access"
  location            = azurerm_resource_group.rg_pass_cool_access.location
  resource_group_name = azurerm_resource_group.rg_pass_cool_access.name
  account_name        = azurerm_netapp_account.account_pass_cool_access.name
  service_level       = "Standard"
  size_in_tb          = 4
  cool_access_enabled = true # ✅ PASS: latest provider history documents cool-access enablement at the pool level
}

resource "azurerm_netapp_volume" "volume_pass_cool_access" {
  name                = "volume-pass-cool-access"
  location            = azurerm_resource_group.rg_pass_cool_access.location
  resource_group_name = azurerm_resource_group.rg_pass_cool_access.name
  account_name        = azurerm_netapp_account.account_pass_cool_access.name
  pool_name           = azurerm_netapp_pool.pool_pass_cool_access.name
  volume_path         = "volpasscoolaccess"
  service_level       = "Standard"
  subnet_id           = azurerm_subnet.subnet_pass_cool_access.id
  protocols           = ["NFSv4.1"]
  storage_quota_in_gb = 100
  tags = {
    environment = "dev"
  }

  cool_access {
    coolness_period_in_days = 31
    retrieval_policy        = "Default"
    tiering_policy          = "Auto" # ✅ PASS: latest documented volume shape for cool access
  }

  export_policy_rule {
    rule_index        = 1
    allowed_clients   = ["0.0.0.0/0"]
    protocols_enabled = ["NFSv4.1"]
    unix_read_only    = false
    unix_read_write   = true
  }
}
