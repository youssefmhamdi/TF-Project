resource "azurerm_resource_group" "rg-spoke" {
  location = var.location
  name     = "${var.prefix-spoke}-rg-${var.spoke-name}"
}

resource "azurerm_virtual_network" "vnet-spoke" {
  name                = "${var.prefix-spoke}-vnet-${var.spoke-name}"
  location            = azurerm_resource_group.rg-spoke.location
  resource_group_name = azurerm_resource_group.rg-spoke.name

  address_space = [var.spoke-address-space]
}

resource "azurerm_subnet" "subnet-spoke" {
  name                 = "${var.prefix-spoke}-subnet-${var.spoke-name}"
  resource_group_name  = azurerm_resource_group.rg-spoke.name
  virtual_network_name = azurerm_virtual_network.vnet-spoke.name
  address_prefixes     = [var.spoke-subnet-address-space]
}

resource "azurerm_network_security_group" "nsg-spoke" {
  name                = "${var.prefix-spoke}-nsg-${var.spoke-name}"
  location            = azurerm_resource_group.rg-spoke.location
  resource_group_name = azurerm_resource_group.rg-spoke.name

  security_rule {
    name                       = "Allow-All-Inbound-From-Infra"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "10.0.0.0/8"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "nsg-assoc-spoke" {
  subnet_id                 = azurerm_subnet.subnet-spoke.id
  network_security_group_id = azurerm_network_security_group.nsg-spoke.id
}

resource "azurerm_virtual_network_peering" "peering-spoke-to-hub" {
  name                      = "${var.prefix-spoke}-peering-${var.spoke-name}-to-hub"
  resource_group_name       = azurerm_resource_group.rg-spoke.name
  virtual_network_name      = azurerm_virtual_network.vnet-spoke.name
  remote_virtual_network_id = var.hub-vnet-id

  allow_forwarded_traffic      = true
  allow_virtual_network_access = true
  allow_gateway_transit        = false
  use_remote_gateways          = false

  depends_on = [azurerm_virtual_network.vnet-spoke]
}

resource "azurerm_route_table" "route-table-spoke" {
  name                = "${var.prefix-spoke}-route-table-${var.spoke-name}"
  location            = azurerm_resource_group.rg-spoke.location
  resource_group_name = azurerm_resource_group.rg-spoke.name

  route {
    name                   = "RouteToHub"
    address_prefix         = "10.0.0.0/8"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = var.ip-vm-nva
  }
}

resource "azurerm_subnet_route_table_association" "route-table-assoc-spoke" {
  subnet_id      = azurerm_subnet.subnet-spoke.id
  route_table_id = azurerm_route_table.route-table-spoke.id
}

