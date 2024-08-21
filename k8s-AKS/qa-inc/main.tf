# https://developer.hashicorp.com/terraform/tutorials/kubernetes/kubernetes-provider?variants=kubernetes%3Aaks

# ----------------------------------------------
#  Variables.tf
# ----------------------------------------------

# This section declares the variable densify_recommendations.  A Terraform export of your Densify recommendations should reside
# in the cuirrent folder in a file named densify.auto.tfvars
variable "densify_recommendations" {
  type = any
}

data "terraform_remote_state" "aks" {
  backend = "local"

  config = {
    path = "../terraform.tfstate"
  }
}

data "azurerm_kubernetes_cluster" "cluster" {
  name                = data.terraform_remote_state.aks.outputs.kubernetes_cluster_name
  resource_group_name = data.terraform_remote_state.aks.outputs.resource_group_name
}

# ----------------------------------------------
#  Versions.tf
# ----------------------------------------------

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      # version = "3.0.2"
      version = "3.116.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.16.1"
    }
  }
}

# ----------------------------------------------
#  Providers.tf
# ----------------------------------------------

# Retrieve AKS cluster information
provider "azurerm" {
  features {}
}

provider "kubernetes" {
  host = data.azurerm_kubernetes_cluster.cluster.kube_config.0.host

  client_certificate     = base64decode(data.azurerm_kubernetes_cluster.cluster.kube_config.0.client_certificate)
  client_key             = base64decode(data.azurerm_kubernetes_cluster.cluster.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.cluster.kube_config.0.cluster_ca_certificate)
}