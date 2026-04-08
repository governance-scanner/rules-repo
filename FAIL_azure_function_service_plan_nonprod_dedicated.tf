# Policy: AzureFunctionAppServicePlanSkuValidator
# Resource type: azurerm_service_plan
# Checked attribute path: sku_name
# Expected: FAIL because non-production service plan uses a dedicated SKU.

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg_fail_service_plan_sku" {
  name     = "rg-fail-service-plan-sku"
  location = "eastus"
}

resource "azurerm_service_plan" "fail_service_plan_sku" {
  name                = "asp-fail-functions-sku"
  location            = azurerm_resource_group.rg_fail_service_plan_sku.location
  resource_group_name = azurerm_resource_group.rg_fail_service_plan_sku.name
  os_type             = "Linux"
  sku_name            = "P1v3" # ❌ FAIL: lower-cased value starts with p
  tags = {
    environment = "dev"
  }
}
