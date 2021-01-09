# README
# https://aws.amazon.com/premiumsupport/knowledge-center/eks-vpc-subnet-discovery/

resource "aws_ec2_tag" "assoc_subnet_with_cluster" {
  # Associate subnets with kubernetes cluster
  for_each    = toset(concat(local.public_subnets, local.private_subnets))
  resource_id = each.value
  key         = "kubernetes.io/cluster/${local.name}"
  value       = "shared" # allows more than one cluster to use the subnet.
}

resource "aws_ec2_tag" "assoc_subnet_with_lb" {
  # Associate subnets with kubernetes cluster
  for_each    = toset(local.public_subnets)
  resource_id = each.value
  key         = "kubernetes.io/role/elb"
  value       = "1"
}

resource "aws_ec2_tag" "assoc_subnet_with_internal_lb" {
  # Associate subnets with kubernetes cluster
  for_each    = toset(local.private_subnets)
  resource_id = each.value
  key         = "kubernetes.io/role/internal-elb"
  value       = "1"
}
