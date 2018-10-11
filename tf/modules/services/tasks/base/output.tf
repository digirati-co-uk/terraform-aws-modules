output "task_definition_arn" {
  description = "ARN of the task definition"
  value       = "${aws_ecs_task_definition.task}"
}
