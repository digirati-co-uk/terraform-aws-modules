variable "prefix" {
  description = "Prefix for AWS resources"
}

variable "log_group_name" {
  description = "Name of CloudWatch Logs group"
}

variable "log_group_region" {
  description = "CloudWatch Logs group region"
}

variable "log_prefix" {
  description = "Prefix for CloudWatch Logs within group"
}

variable "docker_image" {
  description = "URL of Docker image to use"
}

variable "family" {
  description = "Task Definition family name"
}

variable "container_port" {
  description = "Port that the container is expecting to receive traffic on"
  default     = ""
}

variable "container_name" {
  description = "Name of the container"
  default     = ""
}

variable "cpu_reservation" {
  description = "Amount of CPU to reserve for task"
  default     = 0
}

variable "memory_reservation" {
  description = "Amount of memory to reserve for task"
  default     = 128
}

variable "environment_variables" {
  description = "Map of environment variables"
  type        = "map"
  default     = {}
}

variable "environment_variables_length" {
  description = "Length of environment variable map (required)"
  default     = 0
}

variable "command" {
  description = "Override for container command"
  type        = "list"
  default     = []
}

variable "mount_points" {
  description = "List of mount points"
  type        = "list"
  default     = []
}
