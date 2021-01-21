provider "aws" {
  region  = "ap-southeast-1" # change this
  profile = "default"        # can be changed to other profile
}

data "aws_region" "current" {}
data "aws_availability_zones" "all" {}

locals {
  single_az = [data.aws_availability_zones.all.names[0]] # just deploy in one AZ
}

module "k3s-in-existing-vpc" {
  source = "../.."

  # context
  name  = "kay3s"
  stage = "staging"

  # networking
  region               = data.aws_region.current.name
  vpc_id               = "vpc-35504650" # aws ec2 describe-vpcs
  igw_id               = "igw-8076e8e5" # aws ec2 describe-internet-gateways
  cidr_block           = "172.30.32.0/19"
  availability_zones   = local.single_az
  nat_gateway_enabled  = false
  nat_instance_enabled = true
  nat_instance_type    = "t3.micro" # 50% cheaper compared to a Nat Gateway

  # node instances
  master_instance_type = "t3a.small"
  node_count           = 3
  node_instance_arch   = "x86_64"
  node_instance_type   = "t3a.small"
  # # run on Arm architecture, where g == ARM-based graviton
  # node_instance_arch   = "arm64"
  # node_instance_type   = "r6g.medium"
}
