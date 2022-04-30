resource "aws_instance" "main" {
  ami = data.aws_ami.main_linux.id
  instance_type = var.instance_type
  #instance_type = var.instance_type_list[1] # For List
  #instance_type = var.instance_type_map["dev"] # For Map
  key_name = var.instance_keypair
  vpc_security_group_ids = [ 
      aws_security_group.vpc_ssh.id,
      aws_security_group.vpc_web.id
    ]
  # az-start create ec2 with different availability zones
  for_each = toset(data.aws_availability_zones.main.names)
  availability_zone = each.key
  # az-end

  user_data = file("${path.module}/app-install.sh")
  tags = {
    "Name" = "for_each-demo-${each.key}"
    "Description": "${each.value}"
  }
}