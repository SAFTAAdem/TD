provider "google" {
  project = var.project_id
  region  = var.region
}

module "foundation" {
  source = "../modules/gcp_foundation"

  project_id     = var.project_id
  region         = var.region
  zone           = var.zone
  instance_count = var.instance_count
  dns_name       = var.dns_name
}
