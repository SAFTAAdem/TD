output "frontend_ips" {
  value = aws_instance.frontend[*].public_ip
}

output "database_endpoint" {
  value = aws_db_instance.main.endpoint
}

output "frontend_fqdn" {
  value = aws_route53_record.frontend.fqdn
}
