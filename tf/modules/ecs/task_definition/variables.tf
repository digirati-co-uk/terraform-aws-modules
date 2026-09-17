variable "task_name" {
  type = string
}

variable "container_definitions" {}
// This is intentionally untyped.
// If typed you can't have optional nulls which results in some complexity.
// See https://github.com/hashicorp/terraform/issues/19898

variable "launch_types" {
  type    = list(string)
  default = ["FARGATE"]
}

variable "network_mode" {
  default = "awsvpc"
  type    = string
}

variable "cpu" {
  type    = number
  default = null
}

variable "memory" {
  type    = number
  default = null
}

variable "ephemeral_storage" {
  type    = number
  default = 0
}

variable "volumes" {
  type = list(object({
    name      = string
    host_path = string
  }))
  default = []
}

variable "efs_volumes" {
  type = list(object({
    name           = string
    file_system_id = string
    root_directory = string
  }))
  default = []
}

variable "placement_constraints" {
  type = list(object({
    type       = string
    expression = optional(string)
  }))
  default = []
}

variable "enable_self_assume_role" {
  description = "Allow the task role to assume itself and tag the resulting session (e.g. for per-customer scoping via aws:PrincipalTag conditions on resource policies)"
  type        = bool
  default     = false
}
