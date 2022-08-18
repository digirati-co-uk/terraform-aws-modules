output "task_definition_arn" {
  description = "ARN of the task definition"
  value       = length(var.mount_points) == 0 ? join("", aws_ecs_task_definition.task.*.arn) : ""
}

output "task_definition_json" {
  description = "JSON of the rendered task definition"
  value       = data.template_file.definition.rendered
}

output "role_arn" {
  description = "ARN of the task role"
  value       = aws_iam_role.task.arn
}

output "role_name" {
  description = "Name of the task role"
  value       = aws_iam_role.task.name
}

output "role_unique_id" {
  description = "Unique ID of the task role"
  value       = aws_iam_role.task.unique_id
}

output "container_port" {
  description = "Port that the container uses (avoids repetition of value)"
  value       = var.container_port
}
