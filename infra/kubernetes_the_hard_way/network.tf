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

}

# This is okay for me testing as SSH port 22 is exposed to the internet. Don't do this in production OFC!
resource "azurerm_network_security_rule" "kubernetes-allow-ssh" {
  name                        = "kubernetes-allow-ssh"
  priority                    = 1000
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.resource_group.name
  network_security_group_name = azurerm_network_security_group.kubernetes_network_security_group.name
}


resource "azurerm_network_security_rule" "kubernetes-allow-api-server" {
  name                        = "kubernetes-allow-api-server"
  priority                    = 1001
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "6443"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.resource_group.name
  network_security_group_name = azurerm_network_security_group.kubernetes_network_security_group.name
}

resource "azurerm_public_ip" "public_ip" {
  name                = var.PUBLIC_IP_ADDRESS_NAME
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = var.LOCATION
  allocation_method   = "Static"
}

# Load Balancer for exposing Kubernetes API Servers to remote clients.
resource "azurerm_lb" "load_balancer" {
  name                = var.LOAD_BALANCER_NAME
  location            = var.LOCATION
  resource_group_name = azurerm_resource_group.resource_group.name
  frontend_ip_configuration {
    name                 = azurerm_public_ip.public_ip.name
    public_ip_address_id = azurerm_public_ip.public_ip.id
  }
}
resource "azurerm_lb_backend_address_pool" "backend_address_pool" {
  name            = "kubernetes-lb-pool"
  loadbalancer_id = azurerm_lb.load_balancer.id
}
