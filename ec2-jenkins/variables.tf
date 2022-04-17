variable "instances_names" {
    description = "List of config for 3 instances"
    default = []
    type = list
}

variable "ami_templates" {
  type = map
  default = { }
}

variable "regions" {
    type = map
    default = { }
}

variable "availability_zones" {
    type = map
    default = { }
}

variable "vpc_name" { 
    description = "AWS VPC tag name"
    default = ""
}

variable "internet_gateway_name" { 
    description = "AWS internet gateway tag name"
    default = ""
}

variable "router_table_name" {
    description = "AWS route table tag name"
    default = ""
}

variable "subnet_name" {
    description = "AWS subnet tag name"
    default = ""
}

variable "security_group_name" {
    description = "AWS security group tag name"
    default = ""
}

variable "network_interface_name" {
    description = "AWS network interface tag name"
    default = ""
}

variable "elastic_ip_name" {
    description = "AWS elastic IP tag name"
    default = ""
}





