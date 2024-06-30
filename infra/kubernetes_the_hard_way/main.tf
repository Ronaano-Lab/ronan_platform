resource "azurerm_resource_group" "resource_group" {
  name     = var.RESOURCE_GROUP_NAME
  location = var.LOCATION
}

resource "azurerm_availability_set" "availability_set" {
  name                        = "controller-as"
  location                    = var.LOCATION
  resource_group_name         = azurerm_resource_group.resource_group.name
  platform_fault_domain_count = 2
}

resource "azurerm_public_ip" "kubernetes_control_plane_pip" {
  count               = 3
  name                = "pip-kubernetescontroller-dev-aue-${count.index}"
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = var.LOCATION
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "kubernetes_control_plane_nic" {
  count = 3
  name  = "controller-${count.index}-nic"

  ip_configuration {
    name                          = "internal-ip-${count.index}"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.kubernetes_subnet.id
    public_ip_address_id          = azurerm_public_ip.kubernetes_control_plane_pip["${count.index}"].id
  }
  enable_ip_forwarding = true
  location             = var.LOCATION
  resource_group_name  = azurerm_resource_group.resource_group.name
}

resource "azurerm_linux_virtual_machine" "kubernetes_control_plane_vm" {
  count = 3
  name  = "vm-kubernetescontroller-dev-aue-${count.index}"
  size  = "Standard_B1ls"
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  availability_set_id = azurerm_availability_set.availability_set.id

  admin_ssh_key {
    username   = "kube-root"
    public_key = data.azurerm_ssh_public_key.SshPublicKey.public_key
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }
  location              = var.LOCATION
  resource_group_name   = azurerm_resource_group.resource_group.name
  network_interface_ids = [azurerm_network_interface.kubernetes_control_plane_nic["${count.index}"].id]
  admin_username        = "kuberoot"
}


resource "azurerm_public_ip" "kubernetes_worker_pip" {
  count               = 3
  name                = "pip-kubernetesworker-dev-aue-${count.index}"
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = var.LOCATION
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "kubernetes_worker_nic" {
  count = 3
  name  = "worker-${count.index}-nic"

  ip_configuration {
    name                          = "internal-ip-${count.index}"
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.240.0.1${count.index}"
    subnet_id                     = azurerm_subnet.kubernetes_subnet.id
    public_ip_address_id          = azurerm_public_ip.kubernetes_worker_pip["${count.index}"].id
  }
  enable_ip_forwarding = true
  location             = var.LOCATION
  resource_group_name  = azurerm_resource_group.resource_group.name
}

resource "azurerm_linux_virtual_machine" "kubernetes_worker_vm" {
  count = 3
  name  = "vm-kubernetesworker-dev-aue-${count.index}"
  size  = "Standard_B1ls"
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  availability_set_id = azurerm_availability_set.availability_set.id

  admin_ssh_key {
    username   = "kube-root"
    public_key = data.azurerm_ssh_public_key.SshPublicKey.public_key
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }
  location              = var.LOCATION
  resource_group_name   = azurerm_resource_group.resource_group.name
  network_interface_ids = [azurerm_network_interface.kubernetes_worker_nic["${count.index}"].id]
  admin_username        = "kuberoot"
  tags = {
    "pod-cidr" = "10.200.${count.index}.0/24"
  }
}
