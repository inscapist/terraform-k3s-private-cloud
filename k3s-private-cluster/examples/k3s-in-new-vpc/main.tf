provider "aws" {
  region  = "ap-southeast-1" # change this
  profile = "default"        # can be changed to other profile
}

data "aws_region" "current" {}
data "aws_availability_zones" "all" {}

module "vpc" {
  source  = "cloudposse/vpc/aws"
  version = "0.18.1"

  # context
  name  = "fetias-2"
  stage = "test"

  cidr_block = "172.16.0.0/16"
}

module "k3s-in-new-vpc" {
  source = "../.."

  # context
  name  = "fetias-2"
  stage = "test"

  # networking
  region               = data.aws_region.current.name
  vpc_id               = module.vpc.vpc_id
  igw_id               = module.vpc.igw_id
  cidr_block           = module.vpc.vpc_cidr_block
  availability_zones   = data.aws_availability_zones.all.names
  nat_gateway_enabled  = false
  nat_instance_enabled = true
  nat_instance_type    = "t3.micro" # 50% cheaper compared to a Nat Gateway

  # node instances
  master_instance_type = "m6g.medium"

}
