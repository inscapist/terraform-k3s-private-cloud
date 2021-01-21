provider "aws" {
  region  = "ap-southeast-1" # change this
  profile = "default"        # can be changed to other profile
}

data "aws_region" "current" {}
data "aws_availability_zones" "all" {}


module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "k3s"
  cidr = "10.0.0.0/16"

  azs                  = data.aws_availability_zones.all.names
  private_subnets      = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets       = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  enable_dns_hostnames = true
  enable_dns_support   = true

  # optionally,
  enable_nat_gateway = true
  single_nat_gateway = true # or maybe you got money to burn?

  tags = {
    Stage = "test"
  }
}

# # You don't need this if nat_gateway is enabeld
# module "nat" {
#   source = "int128/nat-instance/aws"

#   name                        = "k3s_nat"
#   vpc_id                      = module.vpc.vpc_id
#   public_subnet               = module.vpc.public_subnets[0]
#   private_subnets_cidr_blocks = module.vpc.private_subnets_cidr_blocks
#   private_route_table_ids     = module.vpc.private_route_table_ids
# }

module "k3s-in-new-vpc" {
  source = "../.."

  # context
  name  = "k3s"
  stage = "test"

  # networking
  region                = data.aws_region.current.name
  availability_zones    = data.aws_availability_zones.all.names
  vpc_id                = module.vpc.vpc_id
  public_subnets        = module.vpc.public_subnets
  private_subnets       = module.vpc.private_subnets
  create_discovery_tags = true

  # node instances
  master_instance_type = "t3a.small"
  node_count           = 3
  node_instance_arch   = "x86_64"
  node_instance_type   = "t3a.small"

  # # run on Arm architecture, where g == ARM-based graviton
  # node_instance_arch   = "arm64"
  # node_instance_type   = "r6g.medium"
}
