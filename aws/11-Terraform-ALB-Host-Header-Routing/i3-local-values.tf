# Define Local Values in Terraform
locals {
    owners = var.business_division
    environment = var.environment
    name = "${local.owners}-${local.environment}"
    common_tags = {
        owners = local.owners
        environment = local.environment
    }

    sub_domain_name_1 = "${var.app1_sub_dns_name}.${data.aws_route53_zone.my_domain.name}"
    sub_domain_name_2 = "${var.app2_sub_dns_name}.${data.aws_route53_zone.my_domain.name}"
}