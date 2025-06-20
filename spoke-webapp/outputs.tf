output "vnet-spoke-id" {
  description = "ID of the spoke virtual network"
  value       = azurerm_virtual_network.vnet-spoke.id
}

output "private-dns-zone-name" {
  value = azurerm_private_dns_zone.private_dns_zone_webapp.name
  description = "Name of the private DNS zone for the web app"
}

output "spoke-rg-name" {
  description = "Name of the spoke resource group"
  value       = azurerm_resource_group.rg-spoke.name
}

output "private-dns-zone-rg-name" {
    description = "Name of the resource group for the private DNS zone"
    value       = azurerm_resource_group.rg-private-endpoint.name
}