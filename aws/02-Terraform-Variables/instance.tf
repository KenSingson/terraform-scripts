resource "aws_instance" "main" {
  ami = data.aws_ami.main_linux.id
  instance_type = var.instance_type
  key_name = var.instance_keypair
  vpc_security_group_ids = [ 
      aws_security_group.vpc_ssh.id,
      aws_security_group.vpc_web.id
    ]

  user_data = file("${path.module}/app-install.sh")
  tags = {
    "Name" = "EC2-demo"
  }
}