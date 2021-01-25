provider "aws" {
  region  = "ap-southeast-1" # change this
  profile = "default"        # can be changed to other profile
}

data "aws_region" "current" {}
data "aws_availability_zones" "all" {}

data "aws_vpc" "this" {
  id = "vpc-35504650"
}

data "aws_internet_gateway" "this" {
  filter {
    name   = "attachment.vpc-id"
    values = [data.aws_vpc.this.id]
  }
}

module "subnets" {
  source  = "cloudposse/dynamic-subnets/aws"
  version = "0.34.0"

  name               = "kay3s"
  stage              = "staging"
  vpc_id             = data.aws_vpc.this.id
  igw_id             = data.aws_internet_gateway.this.id
  cidr_block         = "172.30.32.0/19" # taking an unused cidr range
  availability_zones = ["ap-southeast-1a"]
}

module "k3s-in-existing-vpc" {
  # source = "../.."
  source = "sagittaros/private-cloud/k3s"

  # context
  name  = "kay3s"
  stage = "staging"

  # networking
  region                = data.aws_region.current.name
  availability_zones    = data.aws_availability_zones.all.names
  vpc_id                = data.aws_vpc.this.id
  public_subnets        = module.subnets.public_subnet_ids
  private_subnets       = module.subnets.private_subnet_ids
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
