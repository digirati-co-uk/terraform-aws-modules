output "target_group_arn" {
  description = "ARN of ALB target group"
  value       = aws_alb_target_group.service.arn
}

output "service_name" {
  description = "ECS Service name"
  value       = aws_ecs_service.service.name
}