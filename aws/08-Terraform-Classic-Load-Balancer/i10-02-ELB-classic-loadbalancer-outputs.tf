output "elb_id" {
  description = "The name of the ELB"
  value       = module.elb.elb_id
}

output "elb_name" {
  description = "The name of the ELB"
  value       = module.elb.elb_name
}

output "elb_dns_name" {
  description = "The DNS name of the ELB"
  value       = module.elb.elb_dns_name
}