data "azurerm_ssh_public_key" "SshPublicKey" {
  name                = var.KUBERNETES_SSH_KEY
  resource_group_name = VAR.RESOURCE_GROUP_NAME
}
