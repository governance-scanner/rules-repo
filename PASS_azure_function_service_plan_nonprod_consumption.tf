# Policy: AzureFunctionAppServicePlanSkuValidator
# Resource type: azurerm_service_plan
# Checked attribute path: sku_name
# Expected: PASS because non-production service plan uses Consumption SKU Y1.

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg_pass_service_plan_sku" {
  name     = "rg-pass-service-plan-sku"
  location = "eastus"
}

resource "azurerm_service_plan" "pass_service_plan_sku" {
  name                = "asp-pass-functions-sku"
  location            = azurerm_resource_group.rg_pass_service_plan_sku.location
  resource_group_name = azurerm_resource_group.rg_pass_service_plan_sku.name
  os_type             = "Linux"
  sku_name            = "Y1" # ✅ PASS: does not start with b, s, or p
  tags = {
    environment = "dev"
  }
}
