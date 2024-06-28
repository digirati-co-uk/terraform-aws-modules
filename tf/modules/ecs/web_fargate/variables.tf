variable "name" {
  description = "Service name"
}

variable "cluster_id" {
  description = "ECS cluster to deploy into"
}

variable "subnets" {
  description = "List of subnets for ECS service network configuration"
  type        = list(string)
}

variable "vpc" {
  description = "ID of the VPC that the cluster is deployed in"
}

variable "hostname" {
  description = "Hostname to register in Route53"
  default     = ""
}

variable "domain" {
  description = "Apex domain to use (e.g. dlcs.io)"
}

variable "path_patterns" {
  description = "Path patterns to match in ALB"
  type        = list(string)

  default = [
    "/*",
  ]
}

variable "zone_id" {
  description = "ID for the Hosted Zone"
  default     = ""
}

variable "ip_whitelist" {
  description = "List of CIDR blocks to allow web access for"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "load_balancer_arn" {
  description = "Optional ARN of ALB to attach to"
  default     = ""
}

variable "priority" {
  description = "Priority number for the LB listener rule"
  default     = "0"
}

variable "listener_arn" {
  description = "Optional ARN of the ALB HTTPS Listener to attach to"
  default     = ""
}

variable "desired_count" {
  description = "Desired number of services"
  default     = 1
}

variable "container_port" {
  description = "Port number of container"
}

variable "container_name" {
  description = "Name of container"
}

variable "task_definition_arn" {
  description = "ARN of the ECS Task Definition"
}

variable "health_check_matcher" {
  description = "List of HTTP status codes for health check"
  default     = "200,404"
}

variable "health_check_path" {
  description = "Path to test HTTP status for health check"
  default     = "/"
}

variable "health_check_timeout" {
  description = "Timeout for health check (seconds)"
  default     = 10
}

variable "health_check_healthy_threshold" {
  description = "Threshold for number of healthy checks"
  default     = 2
}

variable "health_check_unhealthy_threshold" {
  description = "Threshold for number of unhealthy checks"
  default     = 2
}

variable "health_check_interval" {
  description = "Interval between health checks (seconds)"
  default     = 30
}

variable "deregistration_delay" {
  description = "Target group deregistration delay (seconds)"
  default     = 30
}

variable "health_check_grace_period_seconds" {
  description = "Grace period for health check (seconds)"
  default     = 0
}

variable "create_route53_entry" {
  description = "Whether to create a Route53 entry for the service"
  default     = true
}

variable "scheduling_strategy" {
  description = "Use REPLICA or DAEMON scheduling strategy"
  default     = "REPLICA"
}

variable "security_group_ids" {
  description = "List of security groups for network configuration"
  type        = list(any)
  default     = []
}

variable "use_fargate_spot" {
  description = "Whether to use FARGATE_SPOT capacity provider"
  default     = false
}

variable "ordered_placement_strategies" {
  type = list(object({
    type  = string
    field = string
  }))
  default = []
}

variable "placement_constraints" {
  type = list(object({
    type       = string
    expression = string
  }))
  default = []
}

variable "load_balancer_stickiness_enabled" {
  description = "Whether stickiness should be enabled or not"
  default     = false
}

variable "stickiness_cookie_duration" {
  description = "Name of the cookie used for stickiness"
  default     = 86400 # 1 day
}