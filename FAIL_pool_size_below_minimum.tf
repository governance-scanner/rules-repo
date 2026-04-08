# Policy: AzureNetAppPoolSizeValidator
# Resource type: azurerm_netapp_pool
# Checked attribute path: size_in_tb
# Threshold source: AzureNetAppPoolDefinitions.MIN_POOL_SIZE_IN_TB = 4
# Expected result: FAIL because size_in_tb is less than 4 TiB.

resource "azurerm_resource_group" "rg_fail_pool_size" {
  name     = "rg-netapp-fail-pool-size"
  location = "eastus"
}

resource "azurerm_netapp_account" "account_fail_pool_size" {
  name                = "netappacctfailpoolsize"
  location            = azurerm_resource_group.rg_fail_pool_size.location
  resource_group_name = azurerm_resource_group.rg_fail_pool_size.name
}

resource "azurerm_netapp_pool" "pool_fail_pool_size" {
  name                = "pool-fail-pool-size"
  location            = azurerm_resource_group.rg_fail_pool_size.location
  resource_group_name = azurerm_resource_group.rg_fail_pool_size.name
  account_name        = azurerm_netapp_account.account_fail_pool_size.name
  service_level       = "Standard"
  size_in_tb          = 3 # ❌ FAIL: below AzureNetAppPoolDefinitions.MIN_POOL_SIZE_IN_TB
}
