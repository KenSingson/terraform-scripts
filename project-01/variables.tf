# Declaration

variable "regions" {
  type = map
  default = {
    "singapore" = "ap-southeast-1"
    "sydney" = "ap-southeast-2"
    "jakarta" = "ap-southeast-3"
  }
}

variable "ami_templates" {
  type = map
  default = {
    "ubuntu20.08" = "ami-055d15d9cfddf7bd3"
  }
}

variable "AWS_EC2_INSTANCE_NAME" {
    default = "ins-dev-aps1-st-01"
    type = string
    description = "name of created ec2 instance"
}

variable "availability_zones" {
    type = map
    default = {
        "zone_1a" = "ap-southeast-1a"
        "zone_1b" = "ap-southeast-1b"
        "zone_1c" = "ap-southeast-1c"
    }
}