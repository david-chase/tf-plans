# ----------------------------------------------
#  Variables.tf
# ----------------------------------------------
# This section declares the variable densify_recommendations.  A Terraform export of your Densify recommendations should reside
# in the cuirrent folder in a file named densify.auto.tfvars
variable "densify_recommendations" {
  type = any
}

data "terraform_remote_state" "eks" {
  backend = "local"

  config = {
    path = "../terraform.tfstate"
  }
}

data "aws_eks_cluster" "cluster" {
  name = data.terraform_remote_state.eks.outputs.cluster_name
}

# ----------------------------------------------
#  Versions.tf
# ----------------------------------------------

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.48.0"
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

# Retrieve EKS cluster information
provider "aws" {
  region = data.terraform_remote_state.eks.outputs.region
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args = [
      "eks",
      "get-token",
      "--cluster-name",
      data.aws_eks_cluster.cluster.name
    ]
  }
}