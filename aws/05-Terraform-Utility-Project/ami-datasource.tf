data "aws_ami" "main_linux" {
  most_recent      = true
  owners           = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-*-hvm-*-x86_64-gp2"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

data "aws_availability_zones" "main" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

data "aws_ec2_instance_type_offerings" "main" {
  for_each = toset(data.aws_availability_zones.main.names)
  filter {
      name = "instance-type"
      values = ["t2.micro"]
  }

  filter {
      name = "location"
      values = [each.key]
  }

  location_type = "availability-zone"
}
