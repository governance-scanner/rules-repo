# Policy: AzureNetAppPoolTierValidator
# Resource type: azurerm_netapp_pool
# Checked attribute path: service_level
# Environment gate: tags.environment must match a non-prod value via cs_policies.utils.is_non_prod_environment()
# Threshold source: AzureNetAppPoolDefinitions.EXPENSIVE_TIERS = {"premium", "ultra"}
# Expected result: PASS because non-prod pool uses Standard tier.

resource "azurerm_resource_group" "rg_pass_pool_tier" {
  name     = "rg-netapp-pass-pool-tier"
  location = "eastus"
}

resource "azurerm_netapp_account" "account_pass_pool_tier" {
  name                = "netappacctpasspooltier"
  location            = azurerm_resource_group.rg_pass_pool_tier.location
  resource_group_name = azurerm_resource_group.rg_pass_pool_tier.name
}

resource "azurerm_netapp_pool" "pool_pass_pool_tier" {
  name                = "pool-pass-pool-tier"
  location            = azurerm_resource_group.rg_pass_pool_tier.location
  resource_group_name = azurerm_resource_group.rg_pass_pool_tier.name
  account_name        = azurerm_netapp_account.account_pass_pool_tier.name
  service_level       = "Standard" # ✅ PASS: lower-cased value is not in EXPENSIVE_TIERS
  size_in_tb          = 4
  tags = {
    environment = "dev" # ✅ PASS: ensures the non-prod branch is exercised
  }
}
