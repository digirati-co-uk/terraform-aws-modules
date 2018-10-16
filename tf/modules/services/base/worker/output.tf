output "service_role_name" {
  description = "Name of the ECS service's IAM role"
  value       = "${aws_iam_role.service.name}"
}
