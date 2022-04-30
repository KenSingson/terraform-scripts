# Load Balancer Security Groups

module "loadbalancer_sg" {
    source  = "terraform-aws-modules/security-group/aws"
    version = "4.9.0"

    name = "loadbalancer-sg"
    description = "Security Group for HTTP open for entire Internet, egress ports are open"

    vpc_id = module.vpc.vpc_id

    # Ingress Rules
    ingress_rules = ["http-80-tcp"]
    ingress_cidr_blocks = ["0.0.0.0/0"]

    # Open to CIDRs blocks (rule or from_port+to_port+protocol+description)
    # ingress_with_cidr_blocks = [
    #     {
    #         from_port   = 81
    #         to_port     = 81
    #         protocol    = "TCP"
    #         description = "Sample port 81"
    #         cidr_blocks = "0.0.0.0/0"
    #     },
    # ]
    # Egress Rule
    egress_rules = ["all-all"]
    tags = local.common_tags
}