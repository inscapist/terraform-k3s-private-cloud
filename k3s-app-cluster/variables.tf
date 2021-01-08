variable "vpc_id" {
  description = "VPC id for this cluster, eg. vpc-xxxxxx"
}

variable "cluster_name" {
  description = "Cluster name, in fqdn form, eg. my.k3s.app"
}

variable "region" {
  description = "AWS region in which to deploy cluster"
  default     = "ap-southeast-1"
}

variable "master_instance_type" {
  description = "Instance size for master node"
  default     = "t4g.medium" # 1vcpu, 4GB memory
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

variable "subnets" {
  default     = []
  type        = list(any)
  description = "List of subnet ids to use"
}
