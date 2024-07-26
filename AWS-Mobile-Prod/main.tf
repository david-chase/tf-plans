variable "owner" {
  type = string
  default = "dchase"
}

provider "aws" {
  region = "us-east-2"
  shared_config_files      = ["~/.aws/config"]
  shared_credentials_files = ["~/.aws/credentials"]
  profile                  = "default"
}

variable "densify_recommendations" {
  type = any
}

resource "aws_instance" "ec-pro-duct-1272" {
  ami = "ami-0900fe555666598a2"
  tags =  {
    Name = "ec-pro-duct-1272"
    owner = var.owner
    purpose = "Terraform demo"
  }

  # normal way of sizing an instance by hardcoding the size.
  instance_type = "r4.2xlarge"
  # instance_type = var.densify_recommendations.ec-pro-duct-1272.recommendedType
}

resource "aws_instance" "ex-prepro-dvc-866" {
  ami = "ami-0900fe555666598a2"
  tags =  {
    Name = "ex-prepro-dvc-866"
    owner = var.owner
    purpose = "Terraform demo"
  }

  # normal way of sizing an instance by hardcoding the size.
  instance_type = "c4.2xlarge"
  # instance_type = var.densify_recommendations.ex-prepro-dvc-866.recommendedType
}

resource "aws_instance" "ex-prepro-fifo-420" {
  ami = "ami-0900fe555666598a2"
  tags =  {
    Name = "ex-prepro-fifo-420"
    owner = var.owner
    purpose = "Terraform demo"
  }

  # normal way of sizing an instance by hardcoding the size.
  instance_type = "m4.large"
  # instance_type = var.densify_recommendations.ex-prepro-fifo-420.recommendedType
}