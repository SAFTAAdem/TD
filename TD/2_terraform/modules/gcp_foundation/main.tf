terraform {
  required_providers {
    google = { source = "hashicorp/google" }
  }
}

resource "google_compute_network" "main" {
  project                 = var.project_id
  name                    = "td2-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "main" {
  project       = var.project_id
  name          = "td2-subnet"
  region        = var.region
  network       = google_compute_network.main.id
  ip_cidr_range = "10.10.0.0/24"
}

resource "google_compute_firewall" "web" {
  project = var.project_id
  name    = "td2-allow-web"
  network = google_compute_network.main.name
  allow {
    protocol = "tcp"
    ports    = ["22", "80"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["td2-web"]
}

resource "google_compute_address" "frontend" {
  count   = var.instance_count
  project = var.project_id
  name    = "td2-frontend-ip-${count.index}"
  region  = var.region
}

resource "google_compute_instance" "frontend" {
  count        = var.instance_count
  project      = var.project_id
  name         = "td2-frontend-${count.index}"
  machine_type = "e2-micro"
  zone         = var.zone
  tags         = ["td2-web"]
  boot_disk {
    initialize_params { image = "debian-cloud/debian-12" }
  }
  network_interface {
    subnetwork = google_compute_subnetwork.main.id
    access_config {
      nat_ip = google_compute_address.frontend[count.index].address
    }
  }
}

resource "google_compute_global_address" "private_services" {
  project       = var.project_id
  name          = "td2-private-services"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.main.id
}

resource "google_service_networking_connection" "private_services" {
  network                 = google_compute_network.main.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_services.name]
}

resource "google_sql_database_instance" "main" {
  project             = var.project_id
  name                = "td2-postgres"
  region              = var.region
  database_version    = "POSTGRES_15"
  deletion_protection = false
  depends_on          = [google_service_networking_connection.private_services]
  settings {
    tier              = "db-f1-micro"
    availability_type = "ZONAL"
    ip_configuration {
      ipv4_enabled    = false
      private_network = google_compute_network.main.id
    }
  }
}

resource "google_dns_managed_zone" "main" {
  project  = var.project_id
  name     = replace(trimsuffix(var.dns_name, "."), ".", "-")
  dns_name = var.dns_name
}

resource "google_dns_record_set" "frontend" {
  project      = var.project_id
  managed_zone = google_dns_managed_zone.main.name
  name         = "frontend.${var.dns_name}"
  type         = "A"
  ttl          = 300
  rrdatas      = google_compute_address.frontend[*].address
}
