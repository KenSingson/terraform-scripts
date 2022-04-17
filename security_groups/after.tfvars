regions = {
    "singapore" = "ap-southeast-1"
    "sydney" = "ap-southeast-2"
    "jakarta" = "ap-southeast-3"
}
vpc_main_name = "vpc-dev-aps1-st"
sg_private_name = "nsg-dev-pri-aps1-st"
sg_public_name = "nsg-dev-pub-aps1-st"
sg_public_ingress_rules = {
    "1" = {
        from_port = 80 
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allow 80"
    }
}

sg_public_egress_rules = {
    "1" = {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "All"
    }
}

already_configured = true