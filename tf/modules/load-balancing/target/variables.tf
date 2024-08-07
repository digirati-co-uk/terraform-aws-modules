variable "name" {
  description = "Name of target group"
}

variable "vpc" {
  description = "ID of the VPC that the ALB is deployed in"
}

variable "hostname" {
  description = "Optional hostname, prepended to domain, for host_header rule"
  default     = ""
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
  default     = null
}

variable "stickiness_cookie_duration" {
  description = "Duration of the stickiness cookie.  Only used in the lb_cookie type"
  default     = 86400 # 1 day
}

variable "stickiness_type" {
  description = "The type of stickiness cookie. Can be lb_cookie or app_cookie"
  default     = "lb_cookie"
}

variable "stickiness_cookie_name" {
  description = "Name of the cookie used for stickiness. Only required for the app_cookie type"
  default     = ""
}

variable "load_balancing_algorithm" {
  description = "Determines how the load balancer selects targets when routing requests"
  default     = "round_robin"
  validation {
    condition     = contains(["round_robin", "least_outstanding_requests", "weighted_random"], var.load_balancing_algorithm)
    error_message = "load_balancing_algorithm must be 'round_robin', 'least_outstanding_requests' or 'weighted_random'"
  }
}

variable "load_balancing_anomaly_mitigation" {
  description = "Determines whether to enable target anomaly mitigation. Target anomaly mitigation is only supported if load_balancing_algorithm='weighted_random'"
  default     = "off"

  validation {
    condition     = contains(["on", "off"], var.load_balancing_anomaly_mitigation)
    error_message = "load_balancing_anomaly_mitigation must be 'on' or 'off'"
  }
}
