# Policy: AzureEventHubNamespaceSkuValidator
# Resource type: azurerm_eventhub_namespace
# Checked attribute path: sku
# Expected: FAIL because non-production namespace uses Standard.

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg_fail_eventhub_sku" {
  name     = "rg-fail-eventhub-sku"
  location = "eastus"
}

resource "azurerm_eventhub_namespace" "fail_eventhub_sku" {
  name                = "evhfailnonprodstd"
  location            = azurerm_resource_group.rg_fail_eventhub_sku.location
  resource_group_name = azurerm_resource_group.rg_fail_eventhub_sku.name
  sku                 = "Standard" # ❌ FAIL: matches definitions.AzureEventHubNamespaceDefinitions.SKU_STANDARD in non-prod
  capacity            = 1
  tags = {
    environment = "dev"
  }
}
