output "url" {
  description = "external url"
  value       = var.hostname == "" ? var.domain : "${var.hostname}.${var.domain}"
}

output "target_group_arn" {
  description = "ARN of ALB target group"
  value       = aws_alb_target_group.service.arn
}

output "service_role_name" {
  description = "Name of the ECS service's IAM role"
  value       = aws_iam_role.service.name
}
