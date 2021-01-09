data "aws_vpc" "this" {
  id = var.vpc_id
}

data "aws_subnet_ids" "available" {
  vpc_id = data.aws_vpc.this.id
}

locals {
  public_subnets  = length(var.public_subnets) > 0 ? var.public_subnets : data.aws_subnet_ids.available.ids
  private_subnets = length(var.private_subnets) > 0 ? var.private_subnets : data.aws_subnet_ids.available.ids
}
