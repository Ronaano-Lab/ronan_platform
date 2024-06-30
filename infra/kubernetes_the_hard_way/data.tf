# data "azurerm_ssh_public_key" "SshPublicKey" {
#   name                = var.KUBERNETES_SSH_KEY
#   resource_group_name = azurerm_resource_group.resource_group.name
# }
