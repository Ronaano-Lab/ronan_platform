resource "azurerm_virtual_network" "kubernetes_vnet" {
  resource_group_name = var.RESOURCE_GROUP_NAME
  name                = var.KUBERNETES_VNET_NAME
  location            = var.LOCATION
  address_space       = ["var.KUBERNETES_VNET_CIDR"]
}


