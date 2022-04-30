module "alb" {
    source  = "terraform-aws-modules/alb/aws"
    version = "6.10.0"

    name = "${local.name}-alb"

    load_balancer_type = "application"

    vpc_id             = module.vpc.vpc_id

    subnets            = [
        module.vpc.public_subnets[0],
        module.vpc.public_subnets[1]
    ]
    
    security_groups    = [module.loadbalancer_sg.security_group_id]

    # Listeners
    http_tcp_listeners = [
        {
            port               = 80
            protocol           = "HTTP"
            target_group_index = 0
        }
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
                    target_id = module.private_ec2_instance[0].id
                    port      = 80
                },
                app_vm2 = {
                    target_id = module.private_ec2_instance[1].id
                    port      = 80
                }
            }
            tags = local.common_tags
        }
    ]
    tags = local.common_tags
}