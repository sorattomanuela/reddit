output "this_lb_id" {
  description = "The ID of the load balancer"
  value       = aws_lb.this.id
}

output "this_lb_arn" {
  description = "The ARN of the load balancer"
  value       = aws_lb.this.arn
}

output "this_target_group_arn" {
  description = "The arn of the load balancer target group"
  value       = aws_lb_target_group.this.arn
}
output "this_target_group_name" {
  description = "The name of the load balancer target group"
  value       = aws_lb_target_group.this.name
}