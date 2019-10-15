variable "name" {
  description = "Service name"
}

variable "project" {
  description = "Project tag value"
}

variable "cluster_id" {
  description = "ECS cluster to deploy into"
}

variable "vpc" {
  description = "ID of the VPC that the cluster is deployed in"
}

variable "desired_count" {
  description = "Desired number of services"
  default     = 1
}

variable "task_definition_arn" {
  description = "ARN of the ECS Task Definition"
}

variable "scheduling_strategy" {
  description = "Use REPLICA or DAEMON scheduling strategy"
  default     = "REPLICA"
}
