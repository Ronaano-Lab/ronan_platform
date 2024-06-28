resource "azurerm_virtual_network" "kubernetes_vnet" {
  resource_group_name = var.RESOURCE_GROUP_NAME
  name                = var.KUBERNETES_VNET_NAME
  location            = var.LOCATION
  address_space       = var.KUBERNETES_VNET_CIDR
}


resource "azurerm_subnet" "kubernetes_subnet" {
  name                 = var.KUBERNETES_SUBNET_NAME
  resource_group_name  = var.RESOURCE_GROUP_NAME
  virtual_network_name = azurerm_virtual_network.kubernetes_vnet.name
  address_prefixes     = var.KUBERNETES_VNET_CIDR
}

resource "azurerm_network_security_group" "kubernetes_network_security_group" {
  name                = var.KUBERNETES_NSG_NAME
  location            = var.LOCATION
  resource_group_name = var.RESOURCE_GROUP_NAME

  security_rule = [{
    name                       = "kubernetes-allow-ssh"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    }, {
    name                       = "kubernetes-allow-api-server"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "6443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }]

}
