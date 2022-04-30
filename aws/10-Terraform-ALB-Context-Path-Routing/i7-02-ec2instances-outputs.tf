# bastion public ec2 output
output "ec2_bastion_public_id" {
  description = "The ID of the instance"
  value       = module.public_ec2_instance.id
}

output "ec2_bastion_public_ip" {
  description = "The public IP address assigned to the instance, if applicable. NOTE: If you are using an aws_eip with your instance, you should refer to the EIP's address directly and not use `public_ip` as this field will change after the EIP is attached"
  value       = module.public_ec2_instance.public_ip
}

# private ec2 output 
output "app1_ec2_private_ips" {
  description = "The private IP address assigned to the instance, if applicable. NOTE: If you are using an aws_eip with your instance, you should refer to the EIP's address directly and not use `public_ip` as this field will change after the EIP is attached"
  value       = [for i in module.private_ec2_instance_app1: i.private_ip]
}

output "app2_ec2_private_ips" {
  description = "The private IP address assigned to the instance, if applicable. NOTE: If you are using an aws_eip with your instance, you should refer to the EIP's address directly and not use `public_ip` as this field will change after the EIP is attached"
  value       = [for i in module.private_ec2_instance_app2: i.private_ip]
}

output "app1_ec2_private_instances_ids" {
  description = "The ID of the instance"
  value       = [for i in module.private_ec2_instance_app1: i.id]
}

output "app2_ec2_private_instances_ids" {
  description = "The ID of the instance"
  value       = [for i in module.private_ec2_instance_app2: i.id]
}

