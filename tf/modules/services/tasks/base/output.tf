output "task_definition_arn" {
  description = "ARN of the task definition"
  value       = "${length(var.mount_points) == 0 ? aws_ecs_task_definition.task.arn : ""}"
}

output "role_arn" {
  description = "ARN of the task role"
  value       = "${aws_iam_role.task.arn}"
}

output "role_name" {
  description = "Name of the task role"
  value       = "${aws_iam_role.task.name}"
}
