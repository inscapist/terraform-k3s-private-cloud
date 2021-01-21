resource "aws_ec2_tag" "public_shared_subnet" {
  for_each    = var.create_discovery_tags ? toset([for s in data.aws_subnet.public : s.id]) : toset([])
  resource_id = each.key
  key         = "kubernetes.io/cluster/${local.cluster_id}"
  value       = "shared"
}

resource "aws_ec2_tag" "public_lb" {
  for_each    = var.create_discovery_tags ? toset([for s in data.aws_subnet.public : s.id]) : toset([])
  resource_id = each.key
  key         = "kubernetes.io/role/elb"
  value       = 1
}

resource "aws_ec2_tag" "public_type" {
  for_each    = var.create_discovery_tags ? toset([for s in data.aws_subnet.public : s.id]) : toset([])
  resource_id = each.key
  key         = "subnet-type"
  value       = "public"
}

resource "aws_ec2_tag" "private_shared_subnet" {
  for_each    = var.create_discovery_tags ? toset([for s in data.aws_subnet.private : s.id]) : toset([])
  resource_id = each.key
  key         = "kubernetes.io/cluster/${local.cluster_id}"
  value       = "shared"
}

resource "aws_ec2_tag" "private_lb" {
  for_each    = var.create_discovery_tags ? toset([for s in data.aws_subnet.private : s.id]) : toset([])
  resource_id = each.key
  key         = "kubernetes.io/role/internal-elb"
  value       = 1
}

resource "aws_ec2_tag" "private_type" {
  for_each    = var.create_discovery_tags ? toset([for s in data.aws_subnet.private : s.id]) : toset([])
  resource_id = each.key
  key         = "subnet-type"
  value       = "private"
}
