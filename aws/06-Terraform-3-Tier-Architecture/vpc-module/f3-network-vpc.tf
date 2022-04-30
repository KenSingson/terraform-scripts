module "vpc" {
    source  = "terraform-aws-modules/vpc/aws"
    version = "3.14.0"

    # basic details

    name = "st-vpc"
    cidr = "20.0.0.0/16"

    azs = ["ap-southeast-1a", "ap-southeast-1b"]
    private_subnets = ["20.0.100.0/24", "20.0.101.0/24"]
    public_subnets = ["20.0.1.0/24", "20.0.2.0/24"]

    # database subnets
    create_database_subnet_group = true
    create_database_subnet_route_table = true
    database_subnets = ["20.0.200.0/24", "20.0.201.0/24"]

    # NAT gateway for outbound communication
    enable_nat_gateway = true

    # single nat gateway should be false on production
    single_nat_gateway = true

    # VPC DNS settings
    enable_dns_hostnames = true
    enable_dns_support = true

    public_subnet_tags = {
        Type = "st-pub-subnets"
    }

    private_subnet_tags = {
        Type = "st-pri-subnets"
    }

    database_subnet_tags = {
        Type = "st-db-subnets"
    }

    tags = {
        Owner = "Ken Singson"
        Environment = "test"
    }

    vpc_tags = {
        Name = "st-vpc"
    } 

}