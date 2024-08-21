# https://developer.hashicorp.com/terraform/tutorials/kubernetes/gke
# https://developer.hashicorp.com/terraform/tutorials/kubernetes/kubernetes-provider?variants=kubernetes%3Agke

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
  default     = "n1-standard-2"
}

variable "kubernetes_version" {
  type = string
  default = "1.30"
}

variable "node_count" {
  type = string
  default = "1"
}

variable "purpose" {
  description = "The reason this infra was built"
  type        = string
  default     = "Terraform_demo"
}

variable "project_id" {
  description = "project id"
  default = "gke-testing-430322"
}

variable "region" {
  description = "region"
  default = "us-central1"
}

variable "credentials_file" {
  description = "JSON file containing valid credentials"
  default = "../gcp-credentials.json"
}

# ----------------------------------------------
#  Versions.tf
# ----------------------------------------------

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.74.0"
    }
  }
  required_version = ">= 0.14"
}

# ----------------------------------------------
#  Providers.tf
# ----------------------------------------------
provider "google" {
  credentials = file(var.credentials_file)
  project = var.project_id
  region  = var.region
}


# ----------------------------------------------
#  Resources.tf
# ----------------------------------------------

# VPC
resource "google_compute_network" "vpc" {
  name                    = "${var.cluster_name}-vpc"
  auto_create_subnetworks = "false"
}

# Subnet
resource "google_compute_subnetwork" "subnet" {
  name          = "${var.cluster_name}-subnet"
  region        = var.region
  network       = google_compute_network.vpc.name
  ip_cidr_range = "10.10.0.0/24"
}

# GKE cluster
data "google_container_engine_versions" "gke_version" {
  location = var.region
}

resource "google_container_cluster" "primary" {
  name     = "${var.cluster_name}"
  location = var.region
  min_master_version = var.kubernetes_version

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1

  network    = google_compute_network.vpc.name
  subnetwork = google_compute_subnetwork.subnet.name
}

# Separately Managed Node Pool
resource "google_container_node_pool" "primary_nodes" {
  name       = google_container_cluster.primary.name
  location   = var.region
  cluster    = google_container_cluster.primary.name
  
  version = var.kubernetes_version
  node_count = var.node_count

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    labels =  {
      owner = var.owner
      purpose = var.purpose
      createdate = formatdate( "YYYY-MMM-DD_hh-mm", timestamp() )
      provisionedby = "Terraform"
    }

    # preemptible  = true
    machine_type = var.instance_type
    tags         = ["gke-node", "${var.cluster_name}"]
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}

# ----------------------------------------------
#  Outputs.tf
# ----------------------------------------------

output "region" {
  value       = var.region
  description = "GCloud Region"
}

output "project_id" {
  value       = var.project_id
  description = "GCloud Project ID"
}

output "kubernetes_cluster_name" {
  value       = google_container_cluster.primary.name
  description = "GKE Cluster Name"
}

output "kubernetes_cluster_host" {
  value       = google_container_cluster.primary.endpoint
  description = "GKE Cluster Host"
}