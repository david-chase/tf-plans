terraform{
    required_providers {
      google = {
        source = "hashicorp/google"
        version = "4.51.0"
      }
    }
}

provider "google" {
  credentials = file(var.credentials_file)
  project = "gke-testing-430322"
  region = "northamerica"
  zone = "northeast2-a"
}