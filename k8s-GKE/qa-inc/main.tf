# ----------------------------------------------
#  Variables.tf
# ----------------------------------------------
# This section declares the variable densify_recommendations.  A Terraform export of your Densify recommendations should reside
# in the cuirrent folder in a file named densify.auto.tfvars
variable "densify_recommendations" {
  type = any
}

data "terraform_remote_state" "gke" {
  backend = "local"

  config = {
    path = "../terraform.tfstate"
  }
}

# ----------------------------------------------
#  Versions.tf
# ----------------------------------------------

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.52.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.1"
    }
  }
}

# ----------------------------------------------
#  Providers.tf
# ----------------------------------------------

# Retrieve GKE cluster information
provider "google" {
  project = data.terraform_remote_state.gke.outputs.project_id
  region  = data.terraform_remote_state.gke.outputs.region
}

# Configure kubernetes provider with Oauth2 access token.
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/client_config
# This fetches a new token, which will expire in 1 hour.
data "google_client_config" "default" {}

data "google_container_cluster" "my_cluster" {
  name     = data.terraform_remote_state.gke.outputs.kubernetes_cluster_name
  location = data.terraform_remote_state.gke.outputs.region
}

provider "kubernetes" {
  host = "https://${ data.terraform_remote_state.gke.outputs.kubernetes_cluster_host }"
  token = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(data.google_container_cluster.my_cluster.master_auth[0].cluster_ca_certificate)
}