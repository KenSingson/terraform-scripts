module "elb" {
    source  = "terraform-aws-modules/elb/aws"
    version = "3.0.1"

    name = "${local.name}-elb"

    subnets         = [
        module.vpc.public_subnets[0],
        module.vpc.public_subnets[1]
    ]
    security_groups = [module.loadbalancer_sg.security_group_id]
    # internal        = false

    listener = [
        {
            instance_port     = "80"
            instance_protocol = "http"
            lb_port           = "80"
            lb_protocol       = "http"
        },
        {
            instance_port     = "80"
            instance_protocol = "http"
            lb_port           = "81"
            lb_protocol       = "http"
        },
    ]

    health_check = {
        target              = "HTTP:80/"
        interval            = 30
        healthy_threshold   = 2
        unhealthy_threshold = 2
        timeout             = 5
    }

    tags = local.common_tags

    # ELB attachments
    number_of_instances = var.private_instance_count
    instances           = [ for instance in module.private_ec2_instance: instance.id ]
        # module.private_ec2_instance.id[0],
        # module.private_ec2_instance.id[1]
}