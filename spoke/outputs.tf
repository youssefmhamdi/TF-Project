output "vnet-spoke-id" {
  description = "ID of the spoke virtual network"
  value       = azurerm_virtual_network.vnet-spoke.id
}

output "spoke-rg-name" {
  description = "Name of the spoke resource group"
  value       = azurerm_resource_group.rg-spoke.name
}