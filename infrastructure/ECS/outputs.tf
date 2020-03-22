output "instance_role_name" {
  description = "The name of the EC2 instance role"
  value       = aws_iam_role.ecs-instance-role.name
}
