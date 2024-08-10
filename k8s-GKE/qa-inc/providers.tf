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

# Retrieve GKE cluster information
provider "google" {
  project = data.terraform_remote_state.gke.outputs.project_id
  region  = data.terraform_remote_state.gke.outputs.region
}

provider "kubernetes" {
  # host = data.terraform_remote_state.gke.outputs.kubernetes_cluster_host
  host = "https://${ data.terraform_remote_state.gke.outputs.kubernetes_cluster_host }"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(data.google_container_cluster.gke_cluster.master_auth[0].cluster_ca_certificate)
  # cluster_ca_certificate = base64decode(data.terraform_remote_state.gke.resources.instances.attributes.master_auth.cluster_ca_certificate)
}