variable "prefix" {
  description = "Prefix for AWS resources"
}

variable "name" {
  description = "Suffix for load balancer appliance"
}

variable "subnets" {
  description = "List of subnets to associate load balancer with"
  type        = list(any)
}

variable "security_groups" {
  description = "List of security groups to join"
  type        = list(any)
}

variable "certificate_arn" {
  description = "ARN of wildcard SSL certificate to use"
  default     = ""
}

variable "elb_ssl_policy" {
  description = "SSL policy to use on load balancer"
  default     = "ELBSecurityPolicy-2016-08"
}

variable "vpc" {
  description = "ID of the VPC that the load balancer is deployed in"
}

variable "ip_whitelist" {
  description = "IP CIDR whitelist"
  type        = list(any)

  default = [
    "0.0.0.0/0",
  ]
}

variable "redirect_http_to_https" {
  description = "Enable default behaviour to redirect http to https"
  default     = false
  type        = bool
}

variable "idle_timeout_seconds" {
  description = "Load Balancer idle timeout (seconds)"
  default     = "60"
}

variable "access_logs_bucket" {
  description = "Name of bucket where access_logs will be stored (optional)"
  default     = ""
  type        = string
}

variable "access_logs_prefix" {
  description = "Prefix where access_logs will be stored (optional - ignored if access_logs_bucket empty)"
  default     = null
  type        = string
}
