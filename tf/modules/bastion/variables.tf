variable "vpc" {
  description = "VPC to join"
}

variable "ip_whitelist" {
  description = "List of CIDR blocks to allow SSH access for"
  type        = list(string)
}

variable "prefix" {
  description = "Prefix for AWS resources"
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t3a.micro"
}

variable "ami" {
  description = "AMI ID to use for the bastion instance. Defaults to the latest Amazon Linux 2023 (x86_64) via SSM Parameter Store."
  default     = "resolve:ssm:/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

variable "key_name" {
  description = "EC2 key pair name to use"
}

variable "subnets" {
  description = "VPC subnets to cover with autoscaling group"
  type        = list(string)
}

variable "dns_zone" {
  description = "DNS Hosted Zone ID to create bastion record within"
}

variable "domain" {
  description = "Apex domain to use (e.g. dlcs.io)"
}

variable "hostname" {
  description = "Hostname to register bastion record with. Prepended to domain"
  default     = "bastion"
}

variable "min_size" {
  description = "Minimum number of instances for the cluster"
  default     = 1
}

variable "max_size" {
  description = "Maximum number of instances for the cluster"
  default     = 1
}

variable "additional_security_groups" {
  description = "Additional security groups to assign to Bastion host"
  default     = []
}

variable "host_key_ssm_path" {
  description = "SSM Parameter Store path prefix where the persistent SSH host key is stored. Defaults to /<prefix>/bastion/host-keys"
  type        = string
  default     = null
}

variable "host_key_kms_key_id" {
  description = "ARN of KMS key used to encrypt the stored SSH host key. Defaults to the SSM managed key (alias/aws/ssm)"
  type        = string
  default     = null
  validation {
    # Must be a key ARN as it is used as an IAM policy Resource. Key ids are rejected there, and so
    # are alias ARNs - KMS never matches an alias in a Resource.
    condition     = var.host_key_kms_key_id == null ? true : can(regex("^arn:aws[a-z-]*:kms:[a-z0-9-]+:[0-9]{12}:key/", var.host_key_kms_key_id))
    error_message = "host_key_kms_key_id must be a KMS key ARN (arn:<partition>:kms:<region>:<account>:key/<key-id>). Key ids and aliases are not supported, including alias ARNs, as KMS ignores aliases in an IAM policy Resource."
  }
}

variable "cron_stop" {
  description = "Cron expression when to scale Bastion host in"
  default     = "0 1 1 * *"
}

variable "cron_start" {
  description = "Cron expression when to scale Bastion host out"
  default     = "30 1 1 * *"
}
