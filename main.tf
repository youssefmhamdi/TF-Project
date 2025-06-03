module "hub" {
  source     = "./hub"
  prefix-hub = "tfproject"
}

module "app01" {
  source                     = "./spoke"
  prefix-spoke               = "tfproject"
  spoke-name                 = "app01"
  spoke-address-space        = "10.101.0.0/16"
  spoke-subnet-address-space = "10.101.0.0/24"
  hub-vnet-id                = module.hub.hub-vnet-id
  ip-vm-nva                  = module.hub.hub-vm-nva-ip
  location                   = "North Europe"
  hub-rg-name                = module.hub.hub-rg-name
}

resource "azurerm_virtual_network_peering" "peering-hub-to-app01" {
    name                      = "tfproject-peering-hub-to-app01"
    resource_group_name       = module.hub.hub-rg-name
    virtual_network_name      = module.hub.hub-vnet-name
    remote_virtual_network_id = module.app01.vnet-spoke-id

    allow_forwarded_traffic      = true
    allow_virtual_network_access = true
    allow_gateway_transit        = false
    use_remote_gateways          = false

    depends_on = [module.app01]
}

module "app02" {
  source                     = "./spoke"
  prefix-spoke               = "tfproject"
  spoke-name                 = "app02"
  spoke-address-space        = "10.102.0.0/16"
  spoke-subnet-address-space = "10.102.0.0/24"
  hub-vnet-id                = module.hub.hub-vnet-id
  ip-vm-nva                  = module.hub.hub-vm-nva-ip
  location                   = "North Europe"
  hub-rg-name                = module.hub.hub-rg-name
}

resource "azurerm_virtual_network_peering" "peering-hub-to-app02" {
  name                      = "tfproject-peering-hub-to-app02"
  resource_group_name       = module.hub.hub-rg-name
  virtual_network_name      = module.hub.hub-vnet-name
  remote_virtual_network_id = module.app02.vnet-spoke-id

  allow_forwarded_traffic      = true
  allow_virtual_network_access = true
  allow_gateway_transit        = false
  use_remote_gateways          = false

  depends_on = [module.app02]
}