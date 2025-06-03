output "hub-vnet-id" {
  description = "ID of the hub virtual network"
  value       = azurerm_virtual_network.vnet-hub.id
}

output "hub-vm-nva-ip" {
    description = "Private IP address of the NVA VM in the hub"
  value = azurerm_network_interface.nic-hub-nva.private_ip_address
}

output "hub-rg-name" {
  description = "Name of the hub resource group"
  value       = azurerm_resource_group.rg-hub.name
}

output "hub-vnet-name" {
  description = "Name of the hub virtual network"
  value       = azurerm_virtual_network.vnet-hub.name
}