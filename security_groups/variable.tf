variable "regions" {
    type = map
    default = { }
}

variable "vpc_main_name" { }
variable "sg_private_name" { }
variable "sg_public_name" { }
variable "already_configured" {
    default = false
}
variable "sg_public_ingress_rules" { 
    description = "Public ingress security group rules"
    type = map
}

variable "sg_public_egress_rules" {
    description = "Public egress security group rules"
    type = map
}
