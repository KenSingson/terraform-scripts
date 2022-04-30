resource "aws_instance" "main" {
  ami = "ami-0cc8dc7a69cd8b547"
  instance_type = "t2.micro"

  user_data = file("${path.module}/app-install.sh")
  tags = {
    "Name" = "EC2-demo"
  }
}