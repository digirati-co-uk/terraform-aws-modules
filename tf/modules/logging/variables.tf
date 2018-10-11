variable "project" {
  description = "Project tag value"
}

variable "cloudwatch_log_group_name" {
  description = "CloudWatch Log Group name"
}

variable "cloudwatch_log_retention_days" {
  description = "CloudWatch Log retention in days"
  default     = 3
}
