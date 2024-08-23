variable "name" {}
variable "vpc_id" {}
variable "cidr_block" {}
variable "cidrsubnet_newbits" {}
variable "az_count" {}
variable "map_public_ips_on_launch" {
    default = true
}