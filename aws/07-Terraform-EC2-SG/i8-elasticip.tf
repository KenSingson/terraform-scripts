# Create elastic IP

resource "aws_eip" "main" {
    depends_on = [
        module.public_ec2_instance,
        module.vpc
    ]

    instance = module.public_ec2_instance.id
    vpc = true
    tags = local.common_tags

    provisioner "local-exec" {
        command = "echo VPC destroy on `date` >> destroy-time-eip-id.txt"
        working_dir = "local-exec-output-files"
        when = destroy
    }
}