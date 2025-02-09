terraform {
  required_providers {
    densify = {
      source = "densify.com/provider/densify"
    }
  }
}

# credentials can be passed in as environment variables, DENSIFY_INSTANCE, DENSIFY_USERNAME, DENSIFY_PASSWORD, DENSIFY_TECH_PLATFORM, DENSIFY_ANALYSIS_NAME, DENSIFY_ENTITY_NAME

provider "densify" {
  alias = "audit-deployment"
  tech_platform   = "kubernetes"
  cluster         = "k8master"
  namespace       = "qa-inc"
  controller_type = "deployment"
  pod_name        = "audit-deployment"

  # container_name  = "<container-name>"
  # continue_if_error = true
}

data "densify_container" "reco1" {
  provider = densify.audit-deployment
}

output "data_container1" {
  value = data.densify_container.reco1
  # value = data.densify_container.reco.containers.<container-name>.rec_cpu_req
}

provider "densify" {
  alias = "loader-deployment"
  tech_platform   = "kubernetes"
  cluster         = "k8master"
  namespace       = "qa-inc"
  controller_type = "deployment"
  pod_name        = "loader-deployment"

  # container_name  = "<container-name>"
  # continue_if_error = true
}

data "densify_container" "reco2" {
  provider = densify.loader-deployment
}

output "data_container2" {
  value = data.densify_container.reco2
  # value = data.densify_container.reco.containers.<container-name>.rec_cpu_req
}