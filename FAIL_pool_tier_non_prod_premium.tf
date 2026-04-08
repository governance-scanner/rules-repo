# Policy: AzureNetAppPoolTierValidator
# Resource type: azurerm_netapp_pool
# Checked attribute path: service_level
# Environment gate: tags.environment must match a non-prod value via cs_policies.utils.is_non_prod_environment()
# Threshold source: AzureNetAppPoolDefinitions.EXPENSIVE_TIERS = {"premium", "ultra"}
# Expected result: FAIL because non-prod pool uses Premium tier.

resource "azurerm_resource_group" "rg_fail_pool_tier" {
  name     = "rg-netapp-fail-pool-tier"
  location = "eastus"
}

resource "azurerm_netapp_account" "account_fail_pool_tier" {
  name                = "netappacctfailpooltier"
  location            = azurerm_resource_group.rg_fail_pool_tier.location
  resource_group_name = azurerm_resource_group.rg_fail_pool_tier.name
}

resource "azurerm_netapp_pool" "pool_fail_pool_tier" {
  name                = "pool-fail-pool-tier"
  location            = azurerm_resource_group.rg_fail_pool_tier.location
  resource_group_name = azurerm_resource_group.rg_fail_pool_tier.name
  account_name        = azurerm_netapp_account.account_fail_pool_tier.name
  service_level       = "Premium" # ❌ FAIL: lower-cased value lands in EXPENSIVE_TIERS
  size_in_tb          = 4         # ✅ Passes unrelated pool-size expectations
  tags = {
    environment = "dev" # ✅ Passes environment gate and reaches the service_level check
  }
}
