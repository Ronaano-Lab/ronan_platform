terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.107.0"
    }
  }

  backend "azurerm" {
    subscription_id      = var.SUBSCRIPTION_ID
    resource_group_name  = var.RESOURCE_GROUP_NAME
    storage_account_name = var.STORAGE_ACCOUNT_NAME
    container_name       = var.STORAGE_ACCOUNT_CONTAINER_NAME
    key                  = var.STORAGE_ACCOUNT_KEY
  }
}


provider "azurerm" {

  features {}
  subscription_id = var.SUBSCRIPTION_ID
}
