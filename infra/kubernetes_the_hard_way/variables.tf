variable "RESOURCE_GROUP_NAME" {
  type = string
}

variable "LOCATION" {
  type = string
}

variable "KUBERNETES_VNET_NAME" {
  type = string
}

variable "KUBERNETES_VNET_CIDR" {
  type = list(string)
}

variable "KUBERNETES_SUBNET_NAME" {
  type = string
}

variable "KUBERNETES_NSG_NAME" {
  type = string
}

variable "LOAD_BALANCER_NAME" {
  type = string
}

variable "PUBLIC_IP_ADDRESS_NAME" {
  type = string
}

variable "KUBERNETES_SSH_KEY" {
  type = string
}
