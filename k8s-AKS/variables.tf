# This section declares the variable densify_recommendations.  A Terraform export of your Densify recommendations should reside
# in the cuirrent folder in a file named densify.auto.tfvars
variable "densify_recommendations" {
  type = any
}

variable "resource_group_location" {
  type        = string
  default     = "canadacentral"
  description = "Location of the resource group."
}

variable "resource_group_name" {
  type        = string
  default     = "rg002"
  description = "Name of the resource group for the cluster"
}

variable "resource_group_name_nodepool" {
  type        = string
  default     = "rg003"
  description = "Name of the resource group for the node pool"
}

variable "node_count" {
  type        = number
  description = "The initial quantity of nodes for the node pool."
  default     = 1
}

variable "username" {
  type        = string
  description = "The admin username for the new cluster."
  default     = "azureadmin"
}

variable "cluster_name" {
  type        = string
  description = "The name for the new cluster."
  default     = "akstest"
}

variable "vm_size" {
  type        = string
  description = "The instance type for the cluster nodes."
  default     = "Standard_D2_v2"
}

variable "nodepool_name" {
  type        = string
  description = "The name of the nodepool"
  default     = "nodepool1"
}

variable "kubernetes_version" {
  type        = string
  description = "Kubernetes version of the cluster"
  default     = "1.30"
}

variable "max_nodes" {
  type        = number
  description = "Maximum number of nodes in the scale set"
  default     = 3
}