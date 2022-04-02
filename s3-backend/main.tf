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

resource "aws_s3_bucket" "main" {
    bucket = var.s3_bucket_name
    # description = "s3 for storing terraform state files"

    lifecycle {
      prevent_destroy = true
    }

    object_lock_enabled = true
}

resource "aws_s3_bucket_versioning" "main" {
  bucket = aws_s3_bucket.main.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "main" {
  bucket = aws_s3_bucket.main.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
    name = var.ddb_name
    # description = "dynamoDB for terraform state locking"
    billing_mode = "PAY_PER_REQUEST"
    hash_key = "LockID"

    attribute {
      name = "LockID"
      type = "S"
    }
}