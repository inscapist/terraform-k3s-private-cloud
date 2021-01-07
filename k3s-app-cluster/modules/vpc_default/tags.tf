# README
# https://aws.amazon.com/premiumsupport/knowledge-center/eks-vpc-subnet-discovery/

resource "aws_ec2_tag" "assoc_subnet_with_cluster" {
  # Associate subnets with kubernetes cluster
  for_each    = data.aws_subnet_ids.default.ids
  resource_id = each.value
  key         = "kubernetes.io/cluster/${var.cluster_name}"
  value       = "shared" # allows more than one cluster to use the subnet.
}

resource "aws_ec2_tag" "assoc_subnet_with_lb" {
  # Associate subnets with kubernetes cluster
  for_each    = data.aws_subnet_ids.default.ids
  resource_id = each.value
  key         = "kubernetes.io/role/elb"
  value       = "1"
}
