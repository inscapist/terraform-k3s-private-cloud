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
  name            = var.cluster_name
  master_image_id = var.master_image_id != null ? var.master_image_id : data.aws_ami.ubuntu_focal.id
  node_image_id   = var.node_image_id != null ? var.node_image_id : data.aws_ami.ubuntu_focal.id
  subnets         = length(var.subnets) > 0 ? var.subnets : data.aws_subnet_ids.available.ids
}
