# Policy: AzureRedisEnterpriseClusterSKUValidator
# Resource type: azurerm_redis_enterprise_cluster
# Checked attribute path: sku_name
# Expected: FAIL because non-production uses a SKU outside Balanced_B0/Balanced_B1.

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg_fail_redis_cluster_b2" {
  name     = "rg-fail-redis-cluster-b2"
  location = "eastus"
}

resource "azurerm_redis_enterprise_cluster" "fail_redis_cluster_b2" {
  name                = "redisfailclusterb2"
  resource_group_name = azurerm_resource_group.rg_fail_redis_cluster_b2.name
  location            = azurerm_resource_group.rg_fail_redis_cluster_b2.location
  sku_name            = "Balanced_B3" # ❌ FAIL: not in the policy allowlist
  minimum_tls_version = "1.2"
  tags = {
    environment = "dev"
  }
}
