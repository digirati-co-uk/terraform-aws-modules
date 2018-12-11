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

variable "docker_image_main" {
  description = "URL of Docker image to use for main"
}

variable "docker_image_sidecar" {
  description = "URL of Docker image to use for sidecar"
}

variable "family" {
  description = "Task Definition family name"
}

variable "container_port" {
  description = "Port that the container is expecting to receive traffic on"
  default     = ""
}

variable "container_name_main" {
  description = "Name of the main container"
  default     = ""
}

variable "container_name_sidecar" {
  description = "Name of the sidecar container"
  default     = ""
}

variable "host_port" {
  description = "Optional - Port that the host will receive traffic on"
  default     = "0"
}

variable "cpu_reservation_main" {
  description = "Amount of CPU to reserve for task in main container"
  default     = 0
}

variable "cpu_reservation_sidecar" {
  description = "Amount of CPU to reserve for task in sidecar container"
  default     = 0
}

variable "memory_reservation_main" {
  description = "Amount of memory to reserve for task in main container"
  default     = 128
}

variable "memory_reservation_sidecar" {
  description = "Amount of memory to reserve for task in sidecar container"
  default     = 128
}

variable "environment_variables_main" {
  description = "Map of environment variables for main container"
  type        = "map"
  default     = {}
}

variable "environment_variables_sidecar" {
  description = "Map of environment variables for sidecar container"
  type        = "map"
  default     = {}
}

variable "environment_variables_length_main" {
  description = "Length of environment variable map for main container (required)"
  default     = 0
}

variable "environment_variables_length_sidecar" {
  description = "Length of environment variable map for sidecar container (required)"
  default     = 0
}

variable "command_main" {
  description = "Override for main container command"
  type        = "list"
  default     = []
}

variable "command_sidecar" {
  description = "Override for sidecar container command"
  type        = "list"
  default     = []
}

variable "mount_points_main" {
  description = "List of main container mount points"
  type        = "list"
  default     = []
}

variable "mount_points_sidecar" {
  description = "List of sidecar container mount points"
  type        = "list"
  default     = []
}

variable "links_main" {
  description = "List of links for main container"
  type        = "list"
  default     = []
}

variable "links_sidecar" {
  description = "List of links for sidecar container"
  type        = "list"
  default     = []
}

variable "ulimits_main" {
  description = "Map of ulimits for main container"
  type        = "map"
  default     = {}
}

variable "ulimits_main_length" {
  description = "Length of ulimits map for main container (required)"
  default     = 0
}

variable "ulimits_sidecar" {
  description = "Map of ulimits for sidecar container"
  type        = "map"
  default     = {}
}

variable "ulimits_sidecar_length" {
  description = "Length of ulimits map for sidecar container (required)"
  default     = 0
}

variable "port_mappings" {
  description = "Map of port_mappings"
  type        = "map"
  default     = {}
}

variable "port_mappings_length" {
  description = "Length of port_mappings map (required)"
  default     = 0
}
