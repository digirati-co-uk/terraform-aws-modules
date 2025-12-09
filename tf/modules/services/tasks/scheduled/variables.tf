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

variable "network_configuration" {
  description = "Details of network configuration. Required for awsvpc network mode (ie launch_type is FARGATE)"

  type = object({
    subnets          = list(string)
    security_groups  = list(string)
    assign_public_ip = bool
  })

  default = null
}
