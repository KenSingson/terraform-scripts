# VPC Input Variables

variable "vpc_name" {
    description = "VPC Name"
    type = string
    default = "generic_vpc"
}

variable "vpc_cidr_block" {
    description = "VPC CIDR Block"
    type = string
    default = "20.0.0.0/16"
}

variable "vpc_availability_zones" {
    description = "VPC Availability Zones"
    type = list(string)
    default = [ "ap-southeast-1a", "ap-southeast-1b" ]
}

variable "vpc_public_subnets" {
    description = "VPC Public Subnets"
    type = list(string)
    default = [ "10.0.1.0/24", "10.0.2.0/24"] 
}

variable "vpc_private_subnets" {
    description = "VPC Private Subnets"
    type = list(string)
    default = [ "10.0.101.0/24", "10.0.102.0/24" ]
}

variable "vpc_database_subnets" {
    description = "VPC Database Subnets"
    type = list(string)
    default = [ "10.0.201.0/24", "10.0.202.0/24" ]
}

variable "vpc_create_database_subnet_group" {
    description = "VPC Create Database Subnet Group"
    type = bool
    default = true
}

variable "vpc_create_database_subnet_route_table" {
    description = "VPC Create Database Subnet Route Table"
    type = bool
    default = true
}

variable "vpc_enable_nat_gateway" {
    description = "Enable NAT Gateways for Private Subnets Outbound Communication"
    type = bool
    default = true
}

variable "vpc_single_nat_gateway" {
    description = "Enable only single NAT Gateway in One (1) Availability Zone to save costs during demos"
    type = bool
    default = true
}