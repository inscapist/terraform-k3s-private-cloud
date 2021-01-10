variable "cluster_name" {
  description = "Cluster name, without space"
}

variable "region" {
  description = "AWS region in which to deploy cluster"
  default     = "ap-southeast-1"
}

variable "vpc_id" {
  description = "VPC id for this cluster, eg. vpc-xxxxxx"
}

variable "subnets" {
  default     = []
  type        = list(any)
  description = "List of subnet ids to deploy in. If blank, infer from VPC"
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

