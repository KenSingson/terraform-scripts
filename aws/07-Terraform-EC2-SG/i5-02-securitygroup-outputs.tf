# Bastion Public SG

output "bastion_security_group_id" {
  description = "The ID of the security group"
  value       = module.public_bastion_sg.security_group_id
}
output "bastion_security_group_name" {
  description = "The name of the security group"
  value       = module.public_bastion_sg.security_group_name
}

output "bastion_security_group_vpc_id" {
  description = "The VPC ID"
  value       = module.public_bastion_sg.security_group_vpc_id
}

# Private SG

output "private_security_group_id" {
  description = "The ID of the security group"
  value       = module.private_sg.security_group_id
}
output "private_security_group_name" {
  description = "The name of the security group"
  value       = module.private_sg.security_group_name
}

output "private_security_group_vpc_id" {
  description = "The VPC ID"
  value       = module.private_sg.security_group_vpc_id
}