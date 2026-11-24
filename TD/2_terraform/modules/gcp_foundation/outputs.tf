output "frontend_ips" {
  value = google_compute_address.frontend[*].address
}

output "database_private_ip" {
  value = google_sql_database_instance.main.private_ip_address
}

output "frontend_fqdn" {
  value = google_dns_record_set.frontend.name
}
