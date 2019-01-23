variable "family" {
  description = "Task Definition family name"
}

variable "task_role_name" {
  description = "Name of the role for the task"
}

variable "region" {
  description = "AWS region"
}

variable "account_id" {
  description = "AWS account ID"
}

variable "cluster_arn" {
  description = "ARN of the cluster"
}

variable "schedule_expression" {
  description = "CloudWatch event schedule e.g. cron(30 12 * * ? *)"
}

variable "desired_count" {
  description = "Number of tasks to run"
  default     = 1
}

variable "task_definition_arn" {
  description = "Task Definition ARN"
}
