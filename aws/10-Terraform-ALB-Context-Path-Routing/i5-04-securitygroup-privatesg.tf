# AWS EC2 Security Group Terraform
# Security Group for Private EC2 Instances

# Security Group for Bastion Host

module "private_sg" {
    source  = "terraform-aws-modules/security-group/aws"
    version = "4.9.0"

    name = "private-sg"
    description = "Security Group for HTTP and SSH port open for entire VPC Block, egress ports are open"

    vpc_id = module.vpc.vpc_id

    # Ingress Rules
    ingress_rules = [ "ssh-tcp","http-80-tcp" ]
    ingress_cidr_blocks = [module.vpc.vpc_cidr_block]
    # Egress Rule
    egress_rules = ["all-all"]
    tags = local.common_tags
}