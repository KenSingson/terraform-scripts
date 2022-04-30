# Security Group for Bastion Host

module "public_bastion_sg" {
    source  = "terraform-aws-modules/security-group/aws"
    version = "4.9.0"

    name = "public-bastion-sg"
    description = "Security Group for SSH port open 22, egress ports are open"

    vpc_id = module.vpc.vpc_id

    # Ingress Rules
    ingress_rules = ["ssh-tcp"]
    ingress_cidr_blocks = ["0.0.0.0/0"]
    # Egress Rule
    egress_rules = ["all-all"]
    tags = local.common_tags
}

