output "vnet-spoke-id" {
  description = "ID of the spoke virtual network"
  value       = azurerm_virtual_network.vnet-spoke.id
}