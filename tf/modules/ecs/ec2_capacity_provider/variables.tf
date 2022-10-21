variable "name" {
  type = string
}

variable "max_instances" {
  type    = number
  default = 1
}

variable "instance_type" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "security_group_ids" {
  type = list(string)
}

variable "subnets" {
  type = list(string)
}

variable "use_spot_purchasing" {
  type    = bool
  default = false
}

variable "assign_public_ips" {
  type    = bool
  default = false
}

variable "ami_id" {
  type    = string
  default = null // Uses the latest ECS-optimised AMI by default
}

variable "ebs_size_gb" {
  type    = number
  default = 25
}

variable "ebs_volume_type" {
  type    = string
  default = "gp2"
}

variable "scaling_action_cooldown" {
  type    = number
  default = 120
}

variable "additional_user_data" {
  description = "Additional user_data script to run when creating instances. Default will set cluster name in ecs config"
  type        = string
  default     = null
}

variable "managed_termination_protection" {
  type    = string
  default = "DISABLED"
}

variable "key_name" {
  description = "EC2 key pair name to use"
}