variable "credentials_file" { }

variable "cluster_name" {
    default = "test-cluster"
}

variable "node_count" {
    default = "1"
}

variable "region" {
    default = "northamerica-northeast2-a"
}

variable "machine_type" {
    default = "n1-standard-2"
}

variable "project_id" {
    default = "gke-testing-430322"
}