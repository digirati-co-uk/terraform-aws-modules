variable "ami" {
  description = "AMI to use (should be ECS optimised x64)"
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.medium"
}

variable "cluster_name" {
  description = "Cluster name for AWS resources"
}

variable "prefix" {
  description = "Prefix for AWS resources"
}

variable "project" {
  description = "Project tag value"
}

variable "region" {
  description = "AWS region"
}

variable "key_name" {
  description = "EC2 key pair name to use"
}

variable "subnets" {
  description = "List of VPC subnets to spread cluster across"
  type        = "list"
}

variable "vpc" {
  description = "VPC to join"
}

variable "swap_size_gb" {
  description = "Number of GB to allocate as swap space"
  default     = 32
}

variable "dockerhub_username" {
  description = "DockerHub robot username"
  default     = ""
}

variable "dockerhub_password" {
  description = "DockerHub robot password"
  default     = ""
}

variable "dockerhub_email" {
  description = "DockerHub robot email"
  default     = ""
}

variable "min_size" {
  description = "Minimum number of instances for the cluster"
  default     = 1
}

variable "max_size" {
  description = "Maximum number of instances for the cluster"
  default     = 1
}

variable "root_size" {
  description = "Size in GB for the root partition"
  default     = 40
}

variable "bootstrap_objects_bucket" {
  description = "S3 bucket where config is stored"
  default     = ""
}

variable "docker_size" {
  description = "Size in GB of the Docker volume"
  default     = 40
}

# EFS volume data

variable "mount_point_data" {
  description = "Name of mount point to mount EFS volume data"
  default     = "/data"
}

# EBS volume data

variable "mount_point_data_ebs" {
  description = "Name of mount point to mount EBS volume data"
  default     = "/data-ebs"
}

variable "data_ebs_size" {
  description = "Size in GB of the data EBS volume"
  default     = 100
}

# VPC Peering section

variable "peered_vpc_cidr" {
  description = "Optional peered VPC CIDR block"
  default     = ""
}

variable "peered_vpc_port_from" {
  description = "Optional peered VPC port lower range"
  default     = ""
}

variable "peered_vpc_port_to" {
  description = "Optional peered VPC port upper range"
  default     = ""
}

variable "additional_config" {
  description = "Additional configuration for User Data"
  default     = ""
}

variable "enable_elasticsearch" {
  default = "1"
}
