variable "name" {
  description = "Name of target group"
}

variable "vpc" {
  description = "ID of the VPC that the ALB is deployed in"
}

variable "hostname" {
  description = "Optional hostname, prepended to domain, for host_header rule"
  default = ""
}

variable "domain" {
  description = "Domain name for LB rule"
}

variable "path_patterns" {
  description = "Path patterns to match in ALB"
  type        = list(string)

  default = [
    "/*",
  ]
}

variable "zone_id" {
  description = "HostedZone id for creating Route53 rule"
  default     = ""
}

variable "ip_whitelist" {
  description = "List of CIDR blocks to allow web access for"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "load_balancer_arn" {
  description = "ARN of ALB to attach to"
}

variable "priority" {
  description = "Priority number for the listener"
  default     = "0"
}

variable "listener_arn" {
  description = "ARN of the ALB Listener to attach to"
}

variable "create_route53_entry" {
  description = "Whether to create a Route53 entry for the service"
  default     = true
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

variable "target_type" {
  description = "TargetType for ELB TargetGroup"
  default     = "instance"
}

variable "stickiness_enabled" {
  description = "Whether stickiness should be enabled or not"
  default     = false
}

variable "stickiness_cookie_name" {
  description = "Name of the cookie used for stickiness"
  default     = ""
}