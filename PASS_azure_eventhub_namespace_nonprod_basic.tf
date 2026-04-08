# Policy: AzureEventHubNamespaceSkuValidator
# Resource type: azurerm_eventhub_namespace
# Checked attribute path: sku
# Expected: PASS because non-production namespace uses Basic.

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg_pass_eventhub_sku" {
  name     = "rg-pass-eventhub-sku"
  location = "eastus"
}

resource "azurerm_eventhub_namespace" "pass_eventhub_sku" {
  name                = "evhpassnonprodbasic"
  location            = azurerm_resource_group.rg_pass_eventhub_sku.location
  resource_group_name = azurerm_resource_group.rg_pass_eventhub_sku.name
  sku                 = "Basic" # ✅ PASS: non-prod namespace avoids Standard
  tags = {
    environment = "dev"
  }
}
