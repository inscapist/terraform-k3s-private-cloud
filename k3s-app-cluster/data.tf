# Ubuntu because it is the most user friendly and platform neutral
#
# To list the fields:
# https://docs.aws.amazon.com/cli/latest/reference/ec2/describe-images.html
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/*/ubuntu*.04*server*"] # always LTS
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["arm64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

data "aws_vpc" "this" {
  id = var.vpc_id
}

data "aws_subnet_ids" "available" {
  vpc_id = data.aws_vpc.this.id
}

locals {
  name            = var.cluster_name
  master_count    = 1
  node_count      = 3
  master_ami      = var.master_ami != null ? var.master_ami : data.aws_ami.ubuntu.id
  node_ami        = var.node_ami != null ? var.node_ami : data.aws_ami.ubuntu.id
  master_vol      = 50
  public_subnets  = length(var.public_subnets) > 0 ? var.public_subnets : data.aws_subnet_ids.available.ids
  private_subnets = length(var.private_subnets) > 0 ? var.private_subnets : data.aws_subnet_ids.available.ids
}
