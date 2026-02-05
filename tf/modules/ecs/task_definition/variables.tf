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

variable "ebs_volumes" {
  type = list(object({
    name = string
    ebs_volume_configuration = object({
      encrypted        = optional(bool, true)
      iops             = optional(number)
      size_in_gib      = number
      snapshot_id      = optional(string)
      throughput       = optional(number)
      volume_type      = optional(string, "gp3")
      kms_key_id       = optional(string)
      file_system_type = optional(string)
      role_arn         = string
    })
  }))
  default     = []
  description = "List of EBS volumes to attach to the task"
}

variable "placement_constraints" {
  type = list(object({
    type       = string
    expression = string
  }))
  default = []
}
