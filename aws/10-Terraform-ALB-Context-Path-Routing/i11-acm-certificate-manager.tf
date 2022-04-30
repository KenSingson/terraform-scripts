module "acm" {
    source  = "terraform-aws-modules/acm/aws"
    version = "3.4.1"

    domain_name = data.aws_route53_zone.my_domain.name
    zone_id     = data.aws_route53_zone.my_domain.zone_id

    subject_alternative_names = [
        "*.${data.aws_route53_zone.my_domain.name}"
    ]

    wait_for_validation = true

    tags = local.common_tags
}

# Output

output "acm_certificate_arn" {
  description = "The ARN of the certificate"
  value       = module.acm.acm_certificate_arn
}
