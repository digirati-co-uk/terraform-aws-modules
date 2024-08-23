variable "port_mappings" {
  type = list(object({
    containerPort = number
    hostPort      = number
    protocol      = string
  }))

  default = []
}

variable "log_configuration" {
  type = object({
    logDriver = string
    options   = map(string)
    secretOptions = list(object({
      name      = string
      valueFrom = string
    }))
  })

  default = null
}

variable "read_only_filesystem" {
  description = "When this parameter is true, the container is given read-only access to its root file system."
  default     = null
}

variable "mount_points" {
  type = list(object({
    containerPath = string
    sourceVolume  = string
  }))

  default = []
}

variable "healthcheck" {
  type = object({
    command     = list(string)
    retries     = number
    timeout     = number
    interval    = number
    startPeriod = number
  })

  default = null
}

variable "depends" {
  type = list(object({
    containerName = string
    condition     = string
  }))

  default = null
}

variable "user" {
  type    = string
  default = 0
}

variable "secrets" {
  type    = map(string)
  default = {}
}

variable "environment" {
  type    = map(string)
  default = {}
}

variable "name" {
  type = string
}

variable "essential" {
  type    = bool
  default = true
}

variable "cpu" {
  type    = number
  default = 0
}

variable "volumes_from" {
  type = list(object({
    sourceContainer = string
    readOnly        = bool
  }))

  default = []
}

variable "memory" {
  type    = number
  default = null
}

variable "memory_reservation" {
  type    = number
  default = null
}

variable "image" {
  type = string
}

variable "command" {
  default = null
  type    = list(string)
}

variable "tags" {
  default = null
  type    = map(string)
}

variable "system_controls" {
  type = list(object({
    namespace = string
    value     = string
  }))
  default = []
}

variable "repository_credentials" {
  type = object({
    credentialsParameter = string
  })
  default = null
}

variable "links" {
  type    = list(string)
  default = []
}

variable "resource_requirements" {
  type = list(object({
    type  = string
    value = string
  }))
  default = []
}

variable "ulimits" {
  type    = map(string)
  default = {}
}