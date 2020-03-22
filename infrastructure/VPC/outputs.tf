output "this_vpc_id" {
  description = "The VPC ID"
  value       = data.aws_vpc.default.id
}

output "this_subnet_ids" {
  description = "All the subnet ids"
  value       = data.aws_subnet_ids.all.ids
}

output "elb_security_group_id" {
  description = "The ELB security group ID"
  value       = aws_security_group.elb_security_group.id
}

output "instances_security_group_id" {
  description = "The instances security group ID"
  value       = aws_security_group.instances_security_group.id
}

output "rds_security_group_id" {
  description = "The RDS security group ID"
  value       = aws_security_group.rds_security_group.id
}
