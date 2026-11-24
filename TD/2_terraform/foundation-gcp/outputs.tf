output "frontend_ips" {
  value = module.foundation.frontend_ips
}

output "database_private_ip" {
  value = module.foundation.database_private_ip
}

output "frontend_fqdn" {
  value = module.foundation.frontend_fqdn
}
