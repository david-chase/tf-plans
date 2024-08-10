# GKE Cluster Configurations
resource "google_container_cluster" "gke_cluster" {
  name = var.cluster_name
  location = var.region
  remove_default_node_pool = true
  initial_node_count = 1

  ip_allocation_policy {
      }

  private_cluster_config {
    enable_private_nodes = true
    master_ipv4_cidr_block = "172.30.0.0/28"
  }

}

# Node Pool Configurations
resource "google_container_node_pool" "spot_node_pool" {
  name = "custom-node-pool"
  cluster = google_container_cluster.gke_cluster.id
  node_count = var.node_count
  
  node_config {
    spot = true
    machine_type = var.machine_type
  
  disk_size_gb = 30
  disk_type = "pd-standard"
  oauth_scopes = [
    "https://www.googleapis.com/auth/cloud-platform"
  ]
  }
}