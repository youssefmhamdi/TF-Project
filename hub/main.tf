resource "azurerm_resource_group" "rg-hub" {
  name     = "${var.prefix-hub}-rg-hub"
  location = "northeurope"
}

resource "azurerm_virtual_network" "vnet-hub" {

  resource_group_name = azurerm_resource_group.rg-hub.name
  location            = azurerm_resource_group.rg-hub.location

  address_space = ["10.0.0.0/16"]
  name          = "${var.prefix-hub}-vnet-hub"
}

resource "azurerm_subnet" "subnet-nva" {
  resource_group_name  = azurerm_resource_group.rg-hub.name
  virtual_network_name = azurerm_virtual_network.vnet-hub.name
  address_prefixes     = ["10.0.0.0/24"]
  name                 = "${var.prefix-hub}-subnet-hub-nva"
}

resource "azurerm_network_security_group" "nsg-hub-nva" {
  name                = "${var.prefix-hub}-nsg-hub-nva"
  location            = azurerm_resource_group.rg-hub.location
  resource_group_name = azurerm_resource_group.rg-hub.name

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

resource "azurerm_subnet_network_security_group_association" "nsg-assoc-hub-nva" {
  subnet_id                 = azurerm_subnet.subnet-nva.id
  network_security_group_id = azurerm_network_security_group.nsg-hub-nva.id
}

resource "azurerm_public_ip" "pip-hub-nva" {
  name                = "${var.prefix-hub}-pip-hub-nva"
  location            = azurerm_resource_group.rg-hub.location
  resource_group_name = azurerm_resource_group.rg-hub.name
  allocation_method   = "Static"
}


resource "azurerm_network_interface" "nic-hub-nva" {
  name                  = "${var.prefix-hub}-nic-hub-nva"
  location              = azurerm_resource_group.rg-hub.location
  resource_group_name   = azurerm_resource_group.rg-hub.name
  ip_forwarding_enabled = true

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.subnet-nva.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip-hub-nva.id
  }
}

resource "azurerm_linux_virtual_machine" "vm-hub-nva" {
  location                        = azurerm_resource_group.rg-hub.location
  resource_group_name             = azurerm_resource_group.rg-hub.name
  name                            = "${var.prefix-hub}-vm-hub-nva"
  network_interface_ids           = [azurerm_network_interface.nic-hub-nva.id]
  size                            = "Standard_B1s"
  admin_username                  = "azureuser"
  admin_password                  = "Pa55w.rd1234!"
  disable_password_authentication = false
  provision_vm_agent              = true
  allow_extension_operations      = true

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  os_disk {
    caching              = "None"
    storage_account_type = "Standard_LRS"
  }
}

resource "azurerm_virtual_machine_extension" "vm-nva-ip-forwarding" {
  name                 = "CustomScript"
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"
  virtual_machine_id   = azurerm_linux_virtual_machine.vm-hub-nva.id
  settings = jsonencode({
    "commandToExecute" : "sudo bash -c \"echo net.ipv4.ip_forward=1 | sudo tee /etc/sysctl.conf\"; sudo sysctl -p /etc/sysctl.conf"
  })
}