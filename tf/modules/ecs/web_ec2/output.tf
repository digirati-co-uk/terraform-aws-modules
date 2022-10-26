output "target_group_arn" {
  description = "ARN of ALB target group"
  value       = module.target.target_group_arn
}

output "service_name" {
  description = "ECS Service name"
  value       = aws_ecs_service.service.name
}

output "service_arn" {
  description = "ECS Service arn"
  value       = aws_ecs_service.service.id
}