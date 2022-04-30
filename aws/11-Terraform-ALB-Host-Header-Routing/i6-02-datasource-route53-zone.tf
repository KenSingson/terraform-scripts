data "aws_route53_zone" "my_domain" {
  name         = "seseri.co"
}

# Output Zone ID

output "my_domain_zone_id" {
  description = "Route 53 Zone ID"
  value = data.aws_route53_zone.my_domain.zone_id
}

output "my_domain_name" {
  description = "Route 53 Domain Name"
  value = data.aws_route53_zone.my_domain.name
}