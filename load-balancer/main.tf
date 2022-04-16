terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 4.0"
    }
  }

  backend "s3" {
    bucket = "s3-tfs-gb-st-01"
    key = "global/ec2/load-balancer.tfstate"
    region = "ap-southeast-1"
    dynamodb_table = "ddb-tfl-gb-st-01"
    encrypt = true
  }
}

provider "aws" {
    region = "ap-southeast-1"
}

resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "vpc-lb-apse-st"
  }
}

resource "aws_subnet" "pub_01" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-southeast-1a"

  tags = {
    Name = "sn-pub-lb-apse-1a-st"
  }
}

resource "aws_subnet" "pub_02" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "ap-southeast-1b"

  tags = {
    Name = "sn-pub-lb-apse-1b-st"
  }
}

resource "aws_subnet" "pri_01" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "ap-southeast-1a"

  tags = {
    Name = "sn-pri-lb-apse-1a-st"
  }
}

resource "aws_subnet" "pri_02" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "ap-southeast-1b"

  tags = {
    Name = "sn-pri-lb-apse-1b-st"
  }
}

# internet gateway for public subnets
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "igw-lb-apse-st"
  }
}

# route table for public subnets and internet gateway
resource "aws_route_table" "rt_lb" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "rt-lb-apse-st"
  }
}

# adding two (2) public subnets in table association on rt_lb
resource "aws_route_table_association" "pub_01" {
  subnet_id      = aws_subnet.pub_01.id
  route_table_id = aws_route_table.rt_lb.id
}

resource "aws_route_table_association" "pub_02" {
  subnet_id      = aws_subnet.pub_02.id
  route_table_id = aws_route_table.rt_lb.id
}

# create elastic ip for NAT gateway
resource "aws_eip" "ip" {
  vpc      = true
  tags = {
    Name = "eip-lb-apse-st"
  }
}

# NAT gateway for private subnets to access the internet
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.ip.id
  subnet_id = aws_subnet.pub_01.id
  tags = {
    "Name" = "ng-lb-apse-st"
  }
}

# route table for private subnets and NAT gateway
resource "aws_route_table" "rt_ng_lb" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.main.id
  }

  tags = {
    Name = "rt-ng-lb-apse-st"
  }
}

# adding two (2) private subnets in table association on rt_ng_lb
resource "aws_route_table_association" "pri_01" {
  subnet_id      = aws_subnet.pri_01.id
  route_table_id = aws_route_table.rt_ng_lb.id
}

resource "aws_route_table_association" "pri_02" {
  subnet_id      = aws_subnet.pri_02.id
  route_table_id = aws_route_table.rt_ng_lb.id
}

# create security group for private subnets 
resource "aws_security_group" "nsg_private" {
  name        = "nsg-lb-private-apse-st"
  description = "Allow SSH"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "Custom"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    security_groups = [aws_security_group.lb_80.id]
  }

  tags = {
    Name = "nsg-lb-private-apse-st"
  }
}

# security group for load balancer source of anywhere
resource "aws_security_group" "lb_80" {
  name        = "nsg-lb-public-apse-st"
  description = "HTTP 80"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "http"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 80
    to_port          = 80
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "nsg-lb-public-apse-st"
  }
}

# Two (2) ec2 instances in different private subnets to test load balancer
resource "aws_instance" "ec2-pri-01" {
  instance_type = "t2.micro"
  ami = "ami-0971b4b88a87adeef" # amazon linux 2 AMI (HVM) - Kernel 5.10, SSD Volume Type
  subnet_id = aws_subnet.pri_01.id
  security_groups = [aws_security_group.nsg_private.id]
  key_name = "lb-kp"

  root_block_device {
    volume_size = "10"
  }

  tags = {
    Name = "ec2-lb-pri-1a-st"
  }

  user_data = <<-EOF
                #!/bin/bash
                sudo yum install -y httpd
                sudo systemctl enable httpd
                sudo echo "<center><h1>This is instance 01</h1></center>" > /var/www/html/index.html
                sudo systemtctl start httpd
                EOF
}

resource "aws_instance" "ec2-pri-02" {
  instance_type = "t2.micro"
  ami = "ami-0971b4b88a87adeef" # amazon linux 2 AMI (HVM) - Kernel 5.10, SSD Volume Type
  subnet_id = aws_subnet.pri_02.id
  security_groups = [aws_security_group.nsg_private.id]
  key_name = "lb-kp"

  root_block_device {
    volume_size = "10"
  }

  tags = {
    Name = "ec2-lb-pri-1b-st"
  }

  user_data = <<EOF
    #!/bin/bash
    sudo su -
    sudo yum install -y httpd
    sudo systemctl enable httpd
    sudo echo "<center><h1>This is instance 02</h1></center>" > /var/www/html/index.html
    sudo systemtctl start httpd
    EOF
}

# create target group for load balancer
resource "aws_lb_target_group" "lb_targets" {
  name     = "tg-lb-apse-st"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  tags = {
    Name = "tg-lb-apse-st"
  }
}

# attach ec2 instances to the target group
resource "aws_lb_target_group_attachment" "pri_01" {
  target_group_arn = aws_lb_target_group.lb_targets.arn
  target_id        = aws_instance.ec2-pri-01.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "pri_02" {
  target_group_arn = aws_lb_target_group.lb_targets.arn
  target_id        = aws_instance.ec2-pri-02.id
  port             = 80
}

# create an application load balancer
resource "aws_lb" "main" {
  name               = "lb-apse-st"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_80.id]
  subnets            = [aws_subnet.pub_01.id, aws_subnet.pub_02.id]

  tags = {
    Name = "lb-apse-st"
  }
}

# create listener and forward to target group
resource "aws_lb_listener" "main" {
  load_balancer_arn = aws_lb.main.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.lb_targets.arn
    type             = "forward"
  }
}

resource "aws_lb_target_group_attachment" "main" {
  target_group_arn = aws_lb_target_group.lb_targets.arn
  target_id        = aws_instance.ec2-pri-01.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "main2" {
  target_group_arn = aws_lb_target_group.lb_targets.arn
  target_id        = aws_instance.ec2-pri-02.id
  port             = 80
}









