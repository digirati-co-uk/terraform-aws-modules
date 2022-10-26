output "target_group_arn" {
  description = "ARN of ALB target group"
  value       = aws_alb_target_group.service.arn
}