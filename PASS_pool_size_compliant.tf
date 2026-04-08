# Policy: AzureNetAppPoolSizeValidator
# Resource type: azurerm_netapp_pool
# Checked attribute path: size_in_tb
# Threshold source: AzureNetAppPoolDefinitions.MIN_POOL_SIZE_IN_TB = 4
# Expected result: PASS because size_in_tb is exactly 4 TiB.

resource "azurerm_resource_group" "rg_pass_pool_size" {
  name     = "rg-netapp-pass-pool-size"
  location = "eastus"
}

resource "azurerm_netapp_account" "account_pass_pool_size" {
  name                = "netappacctpasspoolsize"
  location            = azurerm_resource_group.rg_pass_pool_size.location
  resource_group_name = azurerm_resource_group.rg_pass_pool_size.name
}

resource "azurerm_netapp_pool" "pool_pass_pool_size" {
  name                = "pool-pass-pool-size"
  location            = azurerm_resource_group.rg_pass_pool_size.location
  resource_group_name = azurerm_resource_group.rg_pass_pool_size.name
  account_name        = azurerm_netapp_account.account_pass_pool_size.name
  service_level       = "Standard"
  size_in_tb          = 4 # ✅ PASS: matches the minimum allowed pool size exactly
}
