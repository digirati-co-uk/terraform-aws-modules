variable "name" {
  type    = string
  default = ""
}

variable "vpc_name" {
  type    = string
  default = ""
}

variable "region" {
  description = "AWS region"
}

variable "cidr_block" {
  description = "VPC CIDR block"
  default     = "10.0.0.0/16"
}

variable "project" {
  description = "Project tag value"
}
