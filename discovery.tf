resource "aws_ec2_tag" "public_shared_subnet" {
  for_each    = toset([for s in data.aws_subnet.public : s.id])
  resource_id = each.key
  key         = "kubernetes.io/cluster/${local.cluster_id}"
  value       = "shared"
}

resource "aws_ec2_tag" "public_lb" {
  for_each    = toset([for s in data.aws_subnet.public : s.id])
  resource_id = each.key
  key         = "kubernetes.io/role/elb"
  value       = 1
}

resource "aws_ec2_tag" "private_shared_subnet" {
  for_each    = toset([for s in data.aws_subnet.private : s.id])
  resource_id = each.key
  key         = "kubernetes.io/cluster/${local.cluster_id}"
  value       = "shared"
}

resource "aws_ec2_tag" "private_lb" {
  for_each    = toset([for s in data.aws_subnet.private : s.id])
  resource_id = each.key
  key         = "kubernetes.io/role/internal-elb"
  value       = 1
}

