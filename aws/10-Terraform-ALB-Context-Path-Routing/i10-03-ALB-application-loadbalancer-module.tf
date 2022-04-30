module "alb" {
    source  = "terraform-aws-modules/alb/aws"
    version = "6.10.0"

    name = "${local.name}-alb"

    load_balancer_type = "application"

    vpc_id             = module.vpc.vpc_id
    subnets            = [module.vpc.public_subnets[0],module.vpc.public_subnets[1]]
    security_groups    = [module.loadbalancer_sg.security_group_id]

    # Listeners
    http_tcp_listeners = [
        {
            port               = 80
            protocol           = "HTTP"
            action_type           = "redirect"
            #target_group_index = 0
            redirect = {
                port = "443"
                protocol = "HTTPS"
                status_code = "HTTP_302"
            }
        },
    ]
    # Target Groups
    target_groups = [
        {
            name_prefix          = "app1-"
            backend_protocol     = "HTTP"
            backend_port         = 80
            target_type          = "instance"
            deregistration_delay = 10
            health_check = {
                enabled             = true
                interval            = 30
                path                = "/"
                port                = "traffic-port"
                healthy_threshold   = 3
                unhealthy_threshold = 3
                timeout             = 6
                protocol            = "HTTP"
                matcher             = "200-399"
            }
            protocol_version = "HTTP1"
            targets = {
                app_vm1 = {
                    target_id = module.private_ec2_instance_app1[0].id
                    port      = 80
                },
                app_vm2 = {
                    target_id = module.private_ec2_instance_app1[1].id
                    port      = 80
                }
            }
            tags = local.common_tags
        },
        {
            name_prefix          = "app2-"
            backend_protocol     = "HTTP"
            backend_port         = 80
            target_type          = "instance"
            deregistration_delay = 10
            health_check = {
                enabled             = true
                interval            = 30
                path                = "/"
                port                = "traffic-port"
                healthy_threshold   = 3
                unhealthy_threshold = 3
                timeout             = 6
                protocol            = "HTTP"
                matcher             = "200-399"
            }
            protocol_version = "HTTP1"
            targets = {
                app_vm1 = {
                    target_id = module.private_ec2_instance_app2[0].id
                    port      = 80
                },
                app_vm2 = {
                    target_id = module.private_ec2_instance_app2[1].id
                    port      = 80
                }
            }
            tags = local.common_tags
        }
    ]

    https_listeners = [
        {
            port               = 443
            protocol           = "HTTPS"
            certificate_arn    = module.acm.acm_certificate_arn
            action_type = "fixed-response"
            fixed_response = {
                content_type = "text/plain"
                message_body = "Static Message - for Root Context"
                status_code  = "200"
            }
        }
    ]

    https_listener_rules = [
        # Rule-1: /app1* should go to app1 ec2 instances
        {
            https_listener_index = 0

            actions = [
                {
                    type               = "forward"
                    target_group_index = 0
                }
            ]

            conditions = [{
                path_patterns = ["/app1*"]
            }]
        },
        # Rule 2: /app2* should go to app2 ec2 instances
        { 
            https_listener_index = 0

            actions = [
                {
                    type               = "forward"
                    target_group_index = 1
                }
            ]
            conditions = [{
                path_patterns = ["/app2*"]
            }]
        },
    ]

    tags = local.common_tags
}