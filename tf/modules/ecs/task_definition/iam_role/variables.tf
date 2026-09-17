variable "task_name" {
  description = "Name of task role"
}

variable "enable_self_assume_role" {
  description = "Allow the task role to assume itself and tag the resulting session (e.g. for per-customer scoping via aws:PrincipalTag conditions on resource policies)"
  type        = bool
  default     = false
}
