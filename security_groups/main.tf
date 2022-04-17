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

resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = var.vpc_main_name
  }
}

resource "aws_security_group" "sg_public_group" {
    name = var.sg_public_name
    description = "Public Security Group"

    dynamic "ingress" {
        for_each = var.sg_public_ingress_rules
        content {
            from_port = ingress.value.from_port
            to_port = ingress.value.to_port
            protocol = ingress.value.protocol
            cidr_blocks = ingress.value.cidr_blocks
            description = ingress.value.description
        }
    }

    dynamic "egress" {
        for_each = var.sg_public_egress_rules
        content {
            from_port = egress.value.from_port
            to_port = egress.value.to_port
            protocol = egress.value.protocol
            cidr_blocks = egress.value.cidr_blocks
            description = egress.value.description
        }
    }

    tags = {
        Name = var.sg_public_name
    }
}

resource "aws_security_group" "sg_private_group" {
    name = var.sg_private_name
    description = "Private Security Group"

    dynamic "ingress" {
        for_each = var.already_configured ? [] : [1]

        content {
            from_port = "0"
            to_port = "0"
            protocol = "all"
            cidr_blocks = ["0.0.0.0/0"]
            description = "Allow all traffic"
        }
    }

    dynamic "ingress" {
        for_each = var.already_configured ? [1] : []

        content {
            from_port = "80"
            to_port = "80"
            protocol = "tcp"
            security_groups = [aws_security_group.sg_public_group.id]
            description = "Allow public sg traffic"
        }
    }

    tags = {
        Name = var.sg_private_name
    }
}


