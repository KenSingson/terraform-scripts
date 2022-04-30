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
  count = 2
  user_data = file("${path.module}/app-install.sh")
  tags = {
    "Name" = "EC2-demo-${count.index}"
  }
}