# Input Variables

# AWS Region
variable "aws_region" {
    description = "Region in which resource will be created"
    type = string
    default = "ap-southeast-1"
}

# Environment
variable "environment" {
    description = "Environment variable as prefix"
    type = string
    default = "dev"
}

# Business Division
variable "business_division" {
    description = "Business departments in the large organization"
    type = string
    default = "IT"
}