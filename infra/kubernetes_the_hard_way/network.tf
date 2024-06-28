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
