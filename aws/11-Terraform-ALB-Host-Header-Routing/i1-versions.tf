# Terraform Block
terraform {
    required_version = "~> 1.1"

    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 4.0"
        }
        
        null = {
            source = "hashicorp/null"
            version = "~> 3.1"
        }
    }
}

provider "aws" {
    region = var.aws_region
}