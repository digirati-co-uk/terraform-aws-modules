variable "task_name" {
  description = "Name of task role"
}

variable "assume_role_override_policy_documents" {
  description = "Optional override policy documents for assume_role_policy"
  type        = list(string)
  default     = null
}
