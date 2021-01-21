data "aws_ami" "amz2-x86_64" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

data "aws_ami" "amz2-arm64" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "architecture"
    values = ["arm64"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

data "aws_vpc" "this" {
  id = var.vpc_id
}

data "aws_subnet" "public" {
  for_each = toset(var.public_subnets)
  id       = each.key
}

data "aws_subnet" "private" {
  for_each = toset(var.private_subnets)
  id       = each.key
}

locals {
  cluster_id      = module.this.id # unique ID from null label
  master_count    = 1
  node_count      = var.node_count
  master_ami      = data.aws_ami.amz2-x86_64.id
  node_ami        = var.node_instance_arch == "arm64" ? data.aws_ami.amz2-arm64.id : data.aws_ami.amz2-x86_64.id
  master_vol      = 50
  node_vol        = 50
  private_subnets = var.private_subnets
}
