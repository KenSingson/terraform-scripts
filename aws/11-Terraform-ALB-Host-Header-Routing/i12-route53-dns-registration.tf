# Default
resource "aws_route53_record" "www" {
    zone_id = data.aws_route53_zone.my_domain.zone_id
    name    = "default.${data.aws_route53_zone.my_domain.name}"
    type    = "A"
    alias {
        name                   = module.alb.lb_dns_name
        zone_id                = module.alb.lb_zone_id
        evaluate_target_health = true
    }
}

# App1 DNS
resource "aws_route53_record" "app1_dns" {
    zone_id = data.aws_route53_zone.my_domain.zone_id
    name    = "${var.app1_sub_dns_name}.${data.aws_route53_zone.my_domain.name}"
    type    = "A"
    alias {
        name                   = module.alb.lb_dns_name
        zone_id                = module.alb.lb_zone_id
        evaluate_target_health = true
    }
}

# App2 DNS
resource "aws_route53_record" "app2_dns" {
    zone_id = data.aws_route53_zone.my_domain.zone_id
    name    = "${var.app2_sub_dns_name}.${data.aws_route53_zone.my_domain.name}"
    type    = "A"
    alias {
        name                   = module.alb.lb_dns_name
        zone_id                = module.alb.lb_zone_id
        evaluate_target_health = true
    }
}