variable "region" {
  description = "AWS region"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  default     = "10.0.0.0/16"
}

variable "subnet_public_1_cidr" {
  description = "Public subnet 1 CIDR block"
  default     = "10.0.0.0/24"
}

variable "subnet_public_1_az" {
  description = "Public subnet 1 Availability Zone"
}

variable "subnet_public_2_cidr" {
  description = "Public subnet 2 CIDR block"
  default     = "10.0.1.0/24"
}

variable "subnet_public_2_az" {
  description = "Public subnet 2 Availability Zone"
}

variable "subnet_private_1_cidr" {
  description = "Private subnet 1 CIDR block"
  default     = "10.0.2.0/24"
}

variable "subnet_private_1_az" {
  description = "Private subnet 1 Availability Zone"
}

variable "subnet_private_2_cidr" {
  description = "Private subnet 2 CIDR block"
  default     = "10.0.3.0/24"
}

variable "subnet_private_2_az" {
  description = "Private subnet 2 Availability Zone"
}

variable "prefix" {
  description = "Prefix for AWS resources"
}

variable "project" {
  description = "Project tag value"
}
