# Terraform Output

# Output - For Loop with List
output "for_output_list" {
    description = "For Loop with List"
    value = [for instance in aws_instance.main: instance.public_dns]
}

output "for_output_map" {
    description = "For Loops with Map"
    value = {for instance in aws_instance.main: instance.id => instance.public_dns}
}

output "for_output_map_advanced" {
    description = "For Loops with Map - Advanced"
    value = {for index, instance in aws_instance.main: index => instance.public_dns}
}

# Legacy - soon will removed
output "legacy_splat_instance_publicdns" {
    description = "Legacy Splat Operator"
    value = aws_instance.main.*.public_dns
}

# Output Latest Splat
output "latest_splat_instance_publicdns" {
    description = "Generalized latest Splat Operator"
    value = aws_instance.main[*].public_dns
}