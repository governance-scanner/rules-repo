# Policy: AzureRedisEnterpriseClusterSKUValidator
# Resource type: azurerm_redis_enterprise_cluster
# Checked attribute path: sku_name
# Expected: PASS because non-production uses allowlisted Balanced_B1.

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg_pass_redis_cluster_b2" {
  name     = "rg-pass-redis-cluster-b2"
  location = "eastus"
}

resource "azurerm_redis_enterprise_cluster" "pass_redis_cluster_b2" {
  name                = "redispassclusterb2"
  resource_group_name = azurerm_resource_group.rg_pass_redis_cluster_b2.name
  location            = azurerm_resource_group.rg_pass_redis_cluster_b2.location
  sku_name            = "Balanced_B1" # ✅ PASS: allowlisted non-production SKU
  minimum_tls_version = "1.2"
  tags = {
    environment = "dev"
  }
}
