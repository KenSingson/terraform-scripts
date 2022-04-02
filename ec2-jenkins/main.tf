terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 4.0"
    }
  }

  backend "s3" { }
}

provider "aws" {
    region = var.regions["singapore"]
}

# create a vpc
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    "Name" = var.vpc_name
  }
}

# create an internet gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    "Name" = var.internet_gateway_name
  }
}

# create a custom route table
resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  route {
    ipv6_cidr_block        = "::/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = var.router_table_name
  }
}

# create a subnet
resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = var.availability_zones["zone_1a"]

  tags = {
    Name = var.subnet_name
  }
}

# associate subnet to route table
resource "aws_route_table_association" "main" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.main.id
}

# create security group to allow 22, 80, 443
resource "aws_security_group" "main" {
  name        = "allow_web_traffic"
  description = "Allow Web traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "TCP"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "HTTP"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "HTTP"
    from_port        = 50000
    to_port          = 50000
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.security_group_name
    Description = "allow web traffic for ports 22, 80 and 443"
  }
}

# create network interface
resource "aws_network_interface" "main" {
  subnet_id       = aws_subnet.main.id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.main.id]

  tags = {
    "Name" = var.network_interface_name
  }
}

# create an elastic ip
resource "aws_eip" "main" {
  vpc                       = true
  network_interface         = aws_network_interface.main.id
  associate_with_private_ip = "10.0.1.50"

  depends_on = [
    aws_internet_gateway.main
  ]

  tags = {
    "Name" = var.elastic_ip_name
  }
}

# create an ubuntu server
resource "aws_instance" "main" {
  ami = var.ami_templates["ubuntu20.08"]
  instance_type = "t2.micro"
  count = 3
  availability_zone = var.availability_zones["zone_1a"]
  key_name = "kp-dev-aps1-st"
  
  network_interface {
    network_interface_id = aws_network_interface.main.id
    device_index = 0
  }

  tags = {
    "Name" = element(var.instances_names, count.index)
    "Description" = "ubuntu instance"
  }

  user_data = <<-EOF
                #!/bin/bash
                sudo apt update -y
                sudo apt install openjdk-11-jre
                sudo apt install apache2 -y
                sudo systemctl start apache2
                EOF
}