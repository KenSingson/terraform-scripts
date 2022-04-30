resource "aws_route53_record" "www" {
    zone_id = data.aws_route53_zone.my_domain.zone_id
    name    = "apps.${data.aws_route53_zone.my_domain.name}"
    type    = "A"
    alias {
        name                   = module.alb.lb_dns_name
        zone_id                = module.alb.lb_zone_id
        evaluate_target_health = true
    }
}