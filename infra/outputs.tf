output "endpoint" {
  description = "Nimipalvelu proxy endpoint"
  value       = "https://${aws_cloudfront_distribution.this.domain_name}/"
}
