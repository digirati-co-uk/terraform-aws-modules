variable "domain" {
  description = "Apex domain to use (e.g. dlcs.io)"
}

variable "project" {
  description = "Project name for tag values"
}

variable "prefix" {
  description = "Prefix for AWS resources"
}

variable "region" {
  description = "AWS region"
}

variable "vpc" {
  description = "VPC to join"
}
