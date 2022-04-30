# EC2 Instance Module

module "private_ec2_instance_app2" {
    depends_on = [
        module.vpc
    ]

    source  = "terraform-aws-modules/ec2-instance/aws"
    version = "3.5.0"

    count = var.private_instance_count
    name = "${local.name}-private-ec2-app2"
    
    ami                    = data.aws_ami.main_linux.id
    instance_type          = var.instance_type
    key_name               = var.instance_keypair

    vpc_security_group_ids = [module.private_sg.security_group_id]
    subnet_id             = element(module.vpc.private_subnets, count.index)
    # 
    
    # instance_count = var.private_instance_count
    user_data = file("${path.module}/02-httpd-install.sh")
    tags = local.common_tags
}
