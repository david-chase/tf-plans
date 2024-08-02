# Specify the provider (GCP, AWS, Azure)
provider "google" {
    credentials = file( var.credentials_file )
    project = "gke-testing-430322"
    region = "northamerica"
    zone = "northeast2-a"
}