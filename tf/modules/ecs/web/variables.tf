variable "name" {
  description = "Service name"
}

variable "project" {
  description = "Project tag value"
}

variable "cluster_id" {
  description = "ECS cluster to deploy into"
}

variable "subnets" {
  description = "List of subnets to load balance"
  type        = list
}

variable "vpc" {
  description = "ID of the VPC that the cluster is deployed in"
}

variable "hostname" {
  description = "Hostname to register in Route53"
}

variable "domain" {
  description = "Apex domain to use (e.g. dlcs.io)"
}

variable "path_patterns" {
  description = "Path patterns to match in ALB"
  type        = list

  default = [
    "/*",
  ]
}

variable "zone_id" {
  description = "ID for the Hosted Zone"
}

variable "ip_whitelist" {
  description = "List of CIDR blocks to allow web access for"
  type        = list
  default     = ["0.0.0.0/0"]
}

variable "load_balancer_arn" {
  description = "Optional ARN of ALB to attach to"
  default     = ""
}

variable "load_balancer_fqdn" {
  description = "Optional FQDN of ALB to attach to"
  default     = ""
}

variable "load_balancer_zone_id" {
  description = "Optional Zone ID of ALB to attach to"
  default     = ""
}

variable "service_number_https" {
  description = "Priority number for the service's ALB HTTPS listener"
  default     = "0"
}

variable "load_balancer_https_listener_arn" {
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

variable "launch_type" {
  description = "Use EC2, FARGATE or EXTERNAL scheduling strategy"
  default     = "EC2"
}

variable "target_type" {
  description = "TargetType for ELB TargetGroup"
  default     = "instance"
}

variable "security_group_ids" {
  description = "List of security groups for network configuration"
  type        = list
  default     = []
}