resource "azurerm_resource_group" "rg-private-endpoint" {
  name     = "${var.prefix-spoke}-rg-private-endpoint-${var.spoke-name}"
  location = var.location
}

resource "azurerm_private_dns_zone" "private_dns_zone_webapp" {
  name = "privatelink.azurewebsites.net"
  resource_group_name = azurerm_resource_group.rg-private-endpoint.name
}

resource "azurerm_private_endpoint" "private-endpoint" {
  name                = "${var.prefix-spoke}-private-endpoint-${var.spoke-name}"
  location            = azurerm_resource_group.rg-private-endpoint.location
  resource_group_name = azurerm_resource_group.rg-private-endpoint.name
  subnet_id = azurerm_subnet.subnet-spoke.id

  private_service_connection {
    is_manual_connection = false
    name                 = "${var.prefix-spoke}-psc-${var.spoke-name}"
    private_connection_resource_id = azurerm_linux_web_app.webapp.id
    subresource_names = ["sites"]
  }

  private_dns_zone_group {
    name = "${var.prefix-spoke}-dns-group-${var.spoke-name}"
    private_dns_zone_ids = [azurerm_private_dns_zone.private_dns_zone_webapp.id]
  }
}

resource "azurerm_private_dns_cname_record"  "private-dns-cname-webapp" {
  name                = "${var.prefix-spoke}-${var.spoke-name}-${var.webapp-name}.azurewebsites.net"
  record              = "${var.prefix-spoke}-${var.spoke-name}-${var.webapp-name}.privatelink.azurewebsites.net"
  resource_group_name = azurerm_resource_group.rg-private-endpoint.name
  zone_name           = azurerm_private_dns_zone.private_dns_zone_webapp.name
  ttl                 = 0

  depends_on = [azurerm_private_endpoint.private-endpoint]
}

resource "azurerm_private_dns_zone_virtual_network_link" "dns_zone_link" {
  name                  = "${var.prefix-spoke}-dns-link-${var.spoke-name}"
  resource_group_name   = azurerm_resource_group.rg-private-endpoint.name
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_zone_webapp.name
  virtual_network_id    = azurerm_virtual_network.vnet-spoke.id
  registration_enabled = false
}


