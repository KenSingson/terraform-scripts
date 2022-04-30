# Terraform Output

# EC2 Instance
output "instance_publicip" {
    description = "EC2 Instance Public IP"
    #value = aws_instance.main[*].public_ip #Legacy Splat won't work on for_each
    value = [for instance in aws_instance.main: instance.public_ip]
}

# w/ toset
output "instance_publicdns" {
    description = "EC2 Instance Public DNS"
    #value = aws_instance.main[*].public_dns #Even latest splant won't work
    value = toset([for instance in aws_instance.main: instance.public_dns])
}

# w/ tomap
output "instance_publicdns_tomap" {
    description = "EC2 Instance Public DNS Map"
    #value = aws_instance.main[*].public_dns #Even latest splant won't work
    value = tomap({ for az, instance in aws_instance.main: az => instance.public_dns })
}

# Filter output: with Keys functions 
output "instance_offer" {
    description = "availability zones mapped to supported instance types"
    value = keys({
        for az, offer in data.aws_ec2_instance_type_offerings.main: az => offer.instance_types if length(offer.instance_types) != 0
    })
}
