# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

resource "random_pet" "prefix" {}

# Define default tags
variable "default_az_tags" {
  type = map(string)
  description = "(optional) Default tags for Azure resources"
  default = {
    Managed_by = "terraform"
    Environment = "test"
    Owner = "dchase"
    Purpose = "Terraform testing"
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "default" {
  name     = "k8master-rg"
  location = "Canada Central"

  # Apply default tags
  tags = var.default_az_tags
}

resource "azurerm_kubernetes_cluster" "default" {
  name                = "k8master"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  dns_prefix          = "${random_pet.prefix.id}-k8s"
  kubernetes_version  = "1.26.3"

  default_node_pool {
    name            = "default"
    node_count      = 2
    vm_size         = "Standard_D2_v2"
    os_disk_size_gb = 30
  }

  service_principal {
    client_id     = var.appId
    client_secret = var.password
  }

  role_based_access_control_enabled = true

  # Apply default tags
  tags = var.default_az_tags
}
