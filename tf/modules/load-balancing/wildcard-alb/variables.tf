variable "internal" {
  description = "If true the load balancer is internal (private IPs only), otherwise internet-facing. Changing this replaces the load balancer"
  default     = false
  type        = bool
}

variable "create_https_listener" {
  description = "Whether to create the HTTPS listener. If false, certificate_arn is not required and lb_https_listener_arn output is empty"
  default     = true
  type        = bool
}

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
  description = "IP CIDR whitelist. If empty no CIDR ingress rules are added to the LB security group - access must be granted via security_groups"
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

variable "drop_invalid_headers" {
  description = "Whether HTTP headers with header fields that are not valid are removed by the load balancer. ELB requires that message header names contain only alphanumeric characters and hyphens"
  default     = null
  type        = bool
}

variable "enable_deletion_protection" {
  description = "If true, deletion of the load balancer will be disabled via the AWS API"
  default     = null
  type        = bool
}

variable "client_keep_alive" {
  description = "client keep alive value, in seconds. The valid range is 60-604800 seconds. The default is 3600 seconds"
  default     = 3600
  type        = number 
}
