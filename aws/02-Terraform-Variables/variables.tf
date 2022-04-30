#Input variables

#AWS Region
variable "region" {
    description = "Region in which AWS Resource to be created."
    type = string
    default = "ap-southeast-1"
}
# AWS EC2 Instance Type
variable "instance_type" {
    description = "EC2 instance type"
    type = string
    default = "t2.micro"
}
# AWS EC2 Instance Key Pair
variable "instance_keypair" {
    description = "AWS EC2 Key Pair to be associated with EC2 Instance"
    type = string
    default = "terraform-keypair"
}