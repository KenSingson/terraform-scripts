instances_names = ["Jenkins-Master", "Dev-Server", "Prod-Server"]
ami_templates = {"ubuntu20.08" = "ami-055d15d9cfddf7bd3"}
regions = {
    "singapore" = "ap-southeast-1"
    "sydney" = "ap-southeast-2"
    "jakarta" = "ap-southeast-3"
}

availability_zones = {
    "zone_1a" = "ap-southeast-1a"
    "zone_1b" = "ap-southeast-1b"
    "zone_1c" = "ap-southeast-1c"
}

vpc_name = "vpc-dev-aps1-st"
internet_gateway_name = "igw-dev-aps1-st"
router_table_name = "rt-dev-aps1-st"
subnet_name = "sn-dev-aps1-st"
security_group_name = "sg-dev-aps1-st"
network_interface_name = "ni-dev-aps1-st"
elastic_ip_name = "eip-dev-aps1-st"