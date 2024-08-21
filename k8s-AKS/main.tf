# https://developer.hashicorp.com/terraform/tutorials/kubernetes/aks

# ----------------------------------------------
#  Variables.tf
# ----------------------------------------------

variable "owner" {
    type = string
    description = "Your user id (used to tag the resources)"
}

variable "cluster_name" {
  type = string
  default = "k8master"
}

variable "instance_type" {
  description = "Instance type to use for nodes"
  type        = string
  default     = "Standard_D2_v2"
}

variable "kubernetes_version" {
  type = string
  default = "1.30"
}

variable "node_count" {
  type = string
  default = "2"
}

variable "region" {
  description = "Azure region"
  type        = string
  default     = "eastus"
}

variable "nodepool_name" {
  description = "Name of the node pool"
  type        = string
  default     = "nodepool1"
}

variable "purpose" {
  description = "The reason this infra was built"
  type        = string
  default     = "Terraform demo"
}

# ----------------------------------------------
#  Versions.tf
# ----------------------------------------------

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.67.0"
    }
  }
  required_version = ">= 0.14"
}

# ----------------------------------------------
#  Providers.tf
# ----------------------------------------------

provider "azurerm" {
  features {}
  skip_provider_registration = "true"
}

# ----------------------------------------------
#  Resources.tf
# ----------------------------------------------

resource "azurerm_resource_group" "default" {
  name     = "${var.cluster_name}-rg"
  location = var.region

  tags =  {
    owner = var.owner
    purpose = var.purpose
    createdate = formatdate( "YYYY-MMM-DD hh:mm", timestamp() )
    provisionedby = "Terraform"
  }
}

resource "azurerm_kubernetes_cluster" "default" {
  name                = var.cluster_name
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  dns_prefix          = "${var.cluster_name}-k8s"
  kubernetes_version  = var.kubernetes_version

  default_node_pool {
    # name            = var.nodepool_name
    name            = "nodepool1"
    node_count      = var.node_count
    vm_size         = var.instance_type
    os_disk_size_gb = 30

    tags =  {
      owner = var.owner
      purpose = var.purpose
      createdate = formatdate( "YYYY-MMM-DD hh:mm", timestamp() )
      provisionedby = "Terraform"
    }
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin    = "kubenet"
    load_balancer_sku = "standard"
  }


  role_based_access_control_enabled = true

  tags =  {
    owner = var.owner
    purpose = var.purpose
    createdate = formatdate( "YYYY-MMM-DD hh:mm", timestamp() )
    provisionedby = "Terraform"
  }
}

# ----------------------------------------------
#  Outputs.tf
# ----------------------------------------------

output "resource_group_name" {
  value = azurerm_resource_group.default.name
}

output "kubernetes_cluster_name" {
  value = azurerm_kubernetes_cluster.default.name
}

output "host" {
  value = azurerm_kubernetes_cluster.default.kube_config.0.host
  sensitive = true
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.default.kube_config_raw
  sensitive = true
}