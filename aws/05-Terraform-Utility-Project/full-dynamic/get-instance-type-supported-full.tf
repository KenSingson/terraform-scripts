# DataSource for availability_zones
data "aws_availability_zones" "main" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

# DataSource for instance offerings
data "aws_ec2_instance_type_offerings" "main" {
    for_each = toset(data.aws_availability_zones.main.names)
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

# Output
output "output_v3_1" {
    description = "availability zones mapped to supported instance types"
    value = {
        for az, offer in data.aws_ec2_instance_type_offerings.main: az => offer.instance_types
    }
}

# Exclude unsupported availability zones
output "output_v3_2" {
    description = "availability zones mapped to supported instance types"
    value = {
        for az, offer in data.aws_ec2_instance_type_offerings.main: az => offer.instance_types if length(offer.instance_types) != 0
    }
}

# Filter output: with Keys functions 
output "output_v3_3" {
    description = "availability zones mapped to supported instance types"
    value = keys({
        for az, offer in data.aws_ec2_instance_type_offerings.main: az => offer.instance_types if length(offer.instance_types) != 0
    })
}


# Filter output: with Keys functions  - first output
output "output_v3_4" {
    description = "availability zones mapped to supported instance types"
    value = keys({
        for az, offer in data.aws_ec2_instance_type_offerings.main: az => offer.instance_types if length(offer.instance_types) != 0
    })[0]
}

