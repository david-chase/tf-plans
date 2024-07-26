terraform {
  required_version = ">=1.0"

  required_providers {
    azapi = {
      source  = "azure/azapi"
      version = "~>1.5"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "0.9.1"
    }
  }
}

provider "azurerm" {
    features {}
}

resource "azurerm_resource_group" "example" {
    name     = var.resource_group_name
    location = var.resource_group_location
}

resource "azapi_resource_action" "ssh_public_key_gen" {
    type        = "Microsoft.Compute/sshPublicKeys@2022-11-01"
    resource_id = azapi_resource.ssh_public_key.id
    action      = "generateKeyPair"
    method      = "POST"
  
    response_export_values = ["publicKey", "privateKey"]
  }

resource "azapi_resource" "ssh_public_key" {
    type      = "Microsoft.Compute/sshPublicKeys@2022-11-01"
    name      = "sshkey"
    location  = azurerm_resource_group.example.location
    parent_id = azurerm_resource_group.example.id
  }

resource "azurerm_kubernetes_cluster" "example" {
  location            = var.resource_group_location
  name                = var.cluster_name
  resource_group_name = var.resource_group_name
  dns_prefix          = "dns"
  kubernetes_version  = var.kubernetes_version

  identity {
    type = "SystemAssigned"
  }

  default_node_pool {
    name       = var.nodepool_name
    vm_size    = var.vm_size
    node_count = var.node_count

    tags = {
        environment = "test"
        owner = var.username
        purpose = "AKS testing"
      }
  }

  linux_profile {
    admin_username = var.username

    ssh_key {
        key_data = azapi_resource_action.ssh_public_key_gen.output.publicKey
    }
  }

  network_profile {
    network_plugin    = "kubenet"
    load_balancer_sku = "standard"
  }

  tags = {
    environment = "test"
    owner = var.username
    purpose = "AKS testing"
  }
}

output "client_certificate" {
    value     = azurerm_kubernetes_cluster.example.kube_config[0].client_certificate
    sensitive = true
  }
  
  output "kube_config" {
    value = azurerm_kubernetes_cluster.example.kube_config_raw
  
    sensitive = true
  }

  output "key_data" {
    value = azapi_resource_action.ssh_public_key_gen.output.publicKey
  }