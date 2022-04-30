# Terraform Block
terraform {
    required_version = "~> 1.1"

    required_providers {
      aws = {
          source = "hashicorp/aws"
          version = "~> 4.0"
      }
    }
}

provider "aws" {
    region = var.region
}