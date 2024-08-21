# https://developer.hashicorp.com/terraform/tutorials/kubernetes/eks
# https://developer.hashicorp.com/terraform/tutorials/kubernetes/kubernetes-provider?variants=kubernetes%3Aeks

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

variable "kubernetes_version" {
  type = string
  default = "1.30"
}

variable "instance_type" {
  description = "Instance type to use for nodes"
  type        = string
  default     = "m7a.medium"
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-2"
}

variable "purpose" {
  description = "The reason this infra was built"
  type        = string
  default     = "Terraform demo"
}



# Filter out local zones, which are not currently supported 
# with managed node groups
data "aws_availability_zones" "available" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

# https://aws.amazon.com/blogs/containers/amazon-ebs-csi-driver-is-now-generally-available-in-amazon-eks-add-ons/ 
data "aws_iam_policy" "ebs_csi_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

# ----------------------------------------------
#  Versions.tf
# ----------------------------------------------

terraform {

  # cloud {
  #   workspaces {
  #     name = "learn-terraform-eks"
  #   }
  # }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.47.0"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0.5"
    }

    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "~> 2.3.4"
    }
  }

  required_version = "~> 1.3"
}

# ----------------------------------------------
#  Providers.tf
# ----------------------------------------------

provider "aws" {
  region = var.region
}

# ----------------------------------------------
#  Resources.tf
# ----------------------------------------------

module "irsa-ebs-csi" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "5.39.0"

  create_role                   = true
  role_name                     = "AmazonEKSTFEBSCSIRole-${module.eks.cluster_name}"
  provider_url                  = module.eks.oidc_provider
  role_policy_arns              = [data.aws_iam_policy.ebs_csi_policy.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.8.1"

  name = "testing-vpc"

  cidr = "10.0.0.0/16"
  azs  = slice(data.aws_availability_zones.available.names, 0, 3)

  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }
  
  tags =  {
    owner = var.owner
    purpose = var.purpose
    createdate = formatdate( "YYYY-MMM-DD hh:mm", timestamp() )
    provisionedby = "Terraform"
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.8.5"

  cluster_name    = var.cluster_name
  cluster_version = var.kubernetes_version

  cluster_endpoint_public_access           = true
  enable_cluster_creator_admin_permissions = true

  cluster_addons = {
    aws-ebs-csi-driver = {
      service_account_role_arn = module.irsa-ebs-csi.iam_role_arn
    }

    # Enable VPC IP Prefix Delegation
    # This will significantly increase MaxPodsPerNode   
    vpc-cni = {
      before_compute = true
      most_recent    = true # To ensure access to the latest settings provided
      configuration_values = jsonencode({
        env = {
          ENABLE_PREFIX_DELEGATION = "true"
          WARM_PREFIX_TARGET       = "1"
        }
      })
    }
  }

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"
  }

  eks_managed_node_groups = {
    one = {
      name = "node-group-1"

      instance_types = [ var.instance_type ]

      min_size     = 1
      max_size     = 3
      desired_size = 1
    }

    two = {
      name = "node-group-2"

      instance_types = [ var.instance_type ]

      min_size     = 1
      max_size     = 2
      desired_size = 1
    }
    
    tags =  {
      owner = var.owner
      purpose = var.purpose
      createdate = formatdate( "YYYY-MMM-DD hh:mm", timestamp() )
      provisionedby = "Terraform"
    } # tags

  } # eks_managed_node_groups
  
} # module "eks"

# ----------------------------------------------
#  Outputs.tf
# ----------------------------------------------

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "Security group ids attached to the cluster control plane"
  value       = module.eks.cluster_security_group_id
}

output "region" {
  description = "AWS region"
  value       = var.region
}

output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = module.eks.cluster_name
}