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

variable "docker_image_sidecar_1" {
  description = "URL of Docker image to use for sidecar 1"
}

variable "docker_image_sidecar_2" {
  description = "URL of Docker image to use for sidecar 2"
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

variable "container_name_sidecar_1" {
  description = "Name of the sidecar 1 container"
  default     = ""
}

variable "container_name_sidecar_2" {
  description = "Name of the sidecar 2 container"
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

variable "cpu_reservation_sidecar_1" {
  description = "Amount of CPU to reserve for task in sidecar 1 container"
  default     = 0
}

variable "cpu_reservation_sidecar_2" {
  description = "Amount of CPU to reserve for task in sidecar 2 container"
  default     = 0
}

variable "memory_reservation_main" {
  description = "Amount of memory to reserve for task in main container"
  default     = 128
}

variable "memory_reservation_sidecar_1" {
  description = "Amount of memory to reserve for task in sidecar 1 container"
  default     = 128
}

variable "memory_reservation_sidecar_2" {
  description = "Amount of memory to reserve for task in sidecar 2 container"
  default     = 128
}

variable "environment_variables_main" {
  description = "Map of environment variables for main container"
  type        = map
  default     = {}
}

variable "environment_variables_sidecar_1" {
  description = "Map of environment variables for sidecar 1 container"
  type        = map
  default     = {}
}

variable "environment_variables_sidecar_2" {
  description = "Map of environment variables for sidecar 2 container"
  type        = map
  default     = {}
}

variable "command_main" {
  description = "Override for main container command"
  type        = list
  default     = []
}

variable "command_sidecar_1" {
  description = "Override for sidecar 1 container command"
  type        = list
  default     = []
}

variable "command_sidecar_2" {
  description = "Override for sidecar 2 container command"
  type        = list
  default     = []
}

variable "mount_points_main" {
  description = "List of main container mount points"
  type        = list
  default     = []
}

variable "mount_points_sidecar_1" {
  description = "List of sidecar 1 container mount points"
  type        = list
  default     = []
}

variable "mount_points_sidecar_2" {
  description = "List of sidecar 2 container mount points"
  type        = list
  default     = []
}

variable "volumes_from_main" {
  description = "List of main container volumesFrom entries"
  type        = list
  default     = []
}

variable "volumes_from_sidecar_1" {
  description = "List of sidecar 1 container volumesFrom entries"
  type        = list
  default     = []
}

variable "volumes_from_sidecar_2" {
  description = "List of sidecar 2 container volumesFrom entries"
  type        = list
  default     = []
}

variable "links_main" {
  description = "List of links for main container"
  type        = list
  default     = []
}

variable "links_sidecar_1" {
  description = "List of links for sidecar 1 container"
  type        = list
  default     = []
}

variable "links_sidecar_2" {
  description = "List of links for sidecar 2 container"
  type        = list
  default     = []
}

variable "ulimits_main" {
  description = "Map of ulimits for main container"
  type        = map
  default     = {}
}

variable "ulimits_sidecar_1" {
  description = "Map of ulimits for sidecar 1 container"
  type        = map
  default     = {}
}

variable "ulimits_sidecar_2" {
  description = "Map of ulimits for sidecar 2 container"
  type        = map
  default     = {}
}

variable "port_mappings" {
  description = "Map of port_mappings"
  type        = map
  default     = {}
}

variable "port_mappings_length" {
  description = "Length of port_mappings map (required)"
  default     = 0
}

variable "user_main" {
  description = "User to set for main container"
  default     = ""
}

variable "user_sidecar_1" {
  description = "User to set for sidecar 1 container"
  default     = ""
}

variable "user_sidecar_2" {
  description = "User to set for sidecar 2 container"
  default     = ""
}
