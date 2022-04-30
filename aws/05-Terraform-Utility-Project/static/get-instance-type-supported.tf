# Datasource
data "aws_ec2_instance_type_offerings" "main" {
    filter {
        name = "instance-type"
        values = ["t2.micro"]
    }

    filter {
        name = "location"
        values = ["ap-southeast-1b"]
    }

    location_type = "availability-zone"
}

# Output
output "output_v1_1" {
    value = data.aws_ec2_instance_type_offerings.main.instance_types
}