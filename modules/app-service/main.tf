resource "azurerm_service_plan" "this" {
  name                = var.service_plan_name
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = var.os_type
  sku_name            = var.sku_name
  tags                = var.tags
}

resource "azurerm_linux_web_app" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  service_plan_id     = azurerm_service_plan.this.id
  https_only          = true

  identity {
    type = "SystemAssigned"
  }

  site_config {
    always_on           = var.sku_name == "F1" ? false : true
    ftps_state          = "Disabled"
    minimum_tls_version = "1.2"
    health_check_path   = var.health_check_path

    application_stack {
      node_version = var.node_version
    }
  }

  app_settings = var.app_settings
  tags         = var.tags
}
