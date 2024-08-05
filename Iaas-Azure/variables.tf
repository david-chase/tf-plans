# This section declares the variable densify_recommendations.  A Terraform export of your Densify recommendations should reside
# in the cuirrent folder in a file named densify.auto.tfvars
variable "densify_recommendations" {
  type = any
}

variable "owner" {
  type = string
  default = "dchase"
}