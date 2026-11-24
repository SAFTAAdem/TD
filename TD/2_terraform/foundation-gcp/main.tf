variable "access_token" {
  type      = string
  sensitive = true
}
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "8.12.0"
    }
  }
}
provider "google" {
  project      = "polytech-dijon"
  region       = "europe-west1"
  access_token = var.access_token
}

resource "google_compute_network" "vpc" {
  name = "foundation-vpc"
}

resource "google_compute_instance" "vm" {
  count        = 2
  name         = "foundation-vm-${count.index}"
  machine_type = "e2-micro"
  zone         = "europe-west1-b"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    network = google_compute_network.vpc.name
    access_config {}
  }
}

resource "google_compute_global_address" "private_ip_address" {
  name          = "private-ip-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.vpc.id
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = google_compute_network.vpc.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}

resource "google_sql_database_instance" "db" {
  name             = "foundation-db"
  region           = "europe-west1"
  database_version = "POSTGRES_15"

  depends_on = [google_service_networking_connection.private_vpc_connection]

  settings {
    tier = "db-f1-micro"
    ip_configuration {
      ipv4_enabled    = false
      private_network = google_compute_network.vpc.self_link
    }
  }
}

resource "google_dns_managed_zone" "prod" {
  name     = "prod-zone"
  dns_name = "kiowy.com."
}

resource "google_dns_record_set" "frontend" {
  name         = "frontend.${google_dns_managed_zone.prod.dns_name}"
  type         = "A"
  ttl          = 300
  managed_zone = google_dns_managed_zone.prod.name
  rrdatas      = google_compute_instance.vm[*].network_interface[0].access_config[0].nat_ip
}
