# we choose ubuntu because it is the most friendly and platform neutral
data "aws_ami" "ubuntu_focal" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    # we use any latest ubuntu with long term support
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_vpc" "this" {
  id = var.vpc_id
}

data "aws_subnet_ids" "available" {
  vpc_id = data.aws_vpc.this.id
}

locals {
  name         = var.cluster_name
  master_count = 1
  node_count   = 3
  master_ami   = var.master_ami != null ? var.master_ami : data.aws_ami.ubuntu_focal.id
  node_ami     = var.node_ami != null ? var.node_ami : data.aws_ami.ubuntu_focal.id
  master_vol   = 50
  subnets      = length(var.subnets) > 0 ? var.subnets : data.aws_subnet_ids.available.ids
}
