# ----------------------------------------------
# Main
# ----------------------------------------------

variable "cluster_id" {
  type        = string
  description = "Unique cluster ID"
}

# ----------------------------------------------
# Networking
# ----------------------------------------------

variable "region" {
  type        = string
  description = "AWS region in which to deploy cluster"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where subnets will be created (e.g. `vpc-aceb2723`)"
}

variable "availability_zones" {
  type        = list(string)
  description = "List of Availability Zones where subnets will be created"
}

variable "public_subnets" {
  type        = list(string)
  description = "List of public subnet ids. In which to launch LB"
}

variable "private_subnets" {
  type        = list(string)
  description = "List of private subnet ids. Nodes will be created here"
}

# ----------------------------------------------
# Node Instances
# ----------------------------------------------


variable "master_instance_type" {
  description = "Instance size for k3s master. Arm64 not supported yet."
  default     = "t3a.small"
}

variable "node_count" {
  description = "Number of worker nodes"
  default     = 3
}

variable "node_instance_arch" {
  description = "Architecture for k3s instance. Either arm64 (graviton) or x86_64 (intel/amd)"
  default     = "arm64"
}

variable "node_instance_types" {
  type        = list(string)
  description = "Instance size for k3s instance, Must match architecture (codename a=arm, g=graviton)"
  default = [
    "r6g.medium", # 1vcpu, 4GB memory
  ]
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

variable "on_demand_percentage" {
  default     = 100
  type        = number
  description = "Percentage(ratio) of on-demand against spot instances (0-100)"
}

variable "target_group_arns" {
  type        = list(string)
  description = "Attach worker nodes to a list of target groups. (Needed for exposure)"
  default     = []
}
