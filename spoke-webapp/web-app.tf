resource "azurerm_resource_group" "rg-webapp" {
  name     = "${var.prefix-spoke}-rg-${var.webapp-name}"
  location = var.location
}

resource "azurerm_service_plan" "sp-webapp" {
  location            = azurerm_resource_group.rg-webapp.location
  name                = "${var.prefix-spoke}-sp-${var.webapp-name}"
  os_type             = "Linux"
  resource_group_name = azurerm_resource_group.rg-webapp.name
  sku_name            = "P0v3"
}

resource "azurerm_linux_web_app" "webapp" {
  name                = "${var.prefix-spoke}-webapp-${var.webapp-name}"
  location            = azurerm_resource_group.rg-webapp.location
  resource_group_name = azurerm_resource_group.rg-webapp.name
  service_plan_id     = azurerm_service_plan.sp-webapp.id
  public_network_access_enabled = false

  site_config {
    application_stack {
      node_version = "18-lts"
    }
  }
}

resource "azurerm_app_service_source_control" "source-control" {
  app_id = azurerm_linux_web_app.webapp.id
  repo_url           = "https://github.com/Azure-Samples/nodejs-docs-hello-world"
  branch             = "main"

  use_manual_integration = true
  use_mercurial = false
}

