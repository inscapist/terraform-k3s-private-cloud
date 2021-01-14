# Refer https://github.com/cloudposse/terraform-aws-dynamic-subnets
module "subnets" {
  source  = "cloudposse/dynamic-subnets/aws"
  version = "0.34.0"

  vpc_id               = var.vpc_id
  igw_id               = var.igw_id
  cidr_block           = var.cidr_block
  availability_zones   = var.availability_zones
  nat_gateway_enabled  = var.nat_gateway_enabled
  nat_instance_enabled = var.nat_instance_enabled
  nat_instance_type    = var.nat_instance_type

  public_subnets_additional_tags = {
    "kubernetes.io/cluster/${local.cluster_id}" = "shared",
    "kubernetes.io/role/elb"                    = 1
  }

  private_subnets_additional_tags = {
    "kubernetes.io/cluster/${local.cluster_id}" = "shared",
    "kubernetes.io/role/internal-elb"           = 1
  }

  context = module.this.context # inherit context
}
