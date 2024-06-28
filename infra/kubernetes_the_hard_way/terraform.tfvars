# In production you would never put terraform.tfvars in a REPO. But since we're testing it's okay
# Also emphasis on the fact I'm not storing any sensitive data here.

RESOURCE_GROUP_NAME    = "rg-kubernetes-dev-aue-01"
LOCATION               = "australiaeast"
KUBERNETES_VNET_NAME   = "kubernetes-vnet"
KUBERNETES_SUBNET_NAME = "kubernetes-subnet"
KUBERNETES_NSG_NAME    = "nsg-kubernetes-dev-aue-01"
LOAD_BALANCER_NAME     = "lb-kubernetes-dev-aue-01"
PUBLIC_IP_ADDRESS_NAME = "pip-kubernetes-dev-aue-01"
