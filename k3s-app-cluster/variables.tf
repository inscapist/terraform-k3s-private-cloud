variable "cluster_name" {
  description = "Cluster name, without space"
}

variable "region" {
  description = "AWS region in which to deploy cluster"
  default     = "ap-southeast-1"
}

variable "vpc_id" {
  # if you want to create a new VPC, you can use
  # https://github.com/cloudposse/terraform-aws-vpc
  description = "VPC id for this cluster, eg. vpc-xxxxxx. You can create VPC with https://github.com/cloudposse/terraform-aws-vpc"
}

variable "public_subnets" {
  default     = []
  type        = list(any)
  description = "List of public subnet ids to use. If blank, infer from VPC"
}

variable "private_subnets" {
  default     = []
  type        = list(any)
  description = "List of private subnet ids to use. If blank, infer from VPC"
}

variable "nat_gateways_subnets" {
  default     = []
  type        = list(any)
  description = "Create 1 Nat Gateways in each of the listed subnets. Required for SSM"
}

variable "master_ami" {
  description = "AMI for k3s master (defaults to Arm64)"
  default     = null
}

variable "node_ami" {
  description = "AMI for k3s node (defaults to Arm64)"
  default     = null
}

variable "master_instance_type" {
  description = "Instance size for k3s master (defaults to Arm64)"
  default     = "m6g.medium" # 1vcpu, 4GB memory
}

variable "extra_master_security_groups" {
  default     = []
  type        = list(any)
  description = "Additional security groups to attach to k3s server instances"
}

variable "extra_node_security_groups" {
  default     = []
  type        = list(any)
  description = "Additional security groups to attach to k3s agent instances"
}

