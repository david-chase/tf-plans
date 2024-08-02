# This tells AWS to use your existing credentials from the CLI tool
provider "aws" {
  region = "us-east-2"
  shared_config_files      = ["~/.aws/config"]
  shared_credentials_files = ["~/.aws/credentials"]
  profile                  = "default"
}