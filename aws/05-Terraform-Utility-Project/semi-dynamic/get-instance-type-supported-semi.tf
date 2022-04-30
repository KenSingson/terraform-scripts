# Datasource
data "aws_ec2_instance_type_offerings" "main" {
    for_each = toset([ "ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c" ])
    filter {
        name = "instance-type"
        values = ["t2.micro"]
    }

    filter {
        name = "location"
        values = [each.key]
    }

    location_type = "availability-zone"
}

# Output-1
output "output_v2_1" {
    value = [for offer in data.aws_ec2_instance_type_offerings.main: offer.instance_types]
}

# Output-2
output "output_v2_2" {
    value = {
        for az, offer in data.aws_ec2_instance_type_offerings.main: az => offer.instance_types
    }
}