locals { 
  vpc_name = var.name == "" ? var.vpc_name : replace(replace("${var.name}-${var.cidr_block}", "/", "-"), ".", "-")

  cidr_block_public  = cidrsubnet(var.cidr_block, 1, 0)
  cidr_block_private = cidrsubnet(var.cidr_block, 1, 1)
}

module "vpc" {
  source = "./public-private-igw"

  name = local.vpc_name

  cidr_block_vpc = var.cidr_block

  public_az_count           = 3
  cidr_block_public         = local.cidr_block_public
  cidrsubnet_newbits_public = 2

  private_az_count           = 3
  cidr_block_private         = local.cidr_block_private
  cidrsubnet_newbits_private = 2
}
