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
    default = "sample-kp"
}

# AWS EC2 Private Instance Count
variable "private_instance_count" {
    description = "AWS EC2 Private Instances Count"
    type = number
    default = 1
}