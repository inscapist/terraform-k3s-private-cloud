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

variable "create_discovery_tags" {
  type        = bool
  default     = true
  description = "Create tags for subnets to be discoverable"
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

variable "node_instance_type" {
  description = "Instance size for k3s instance, Must match architecture (codename a=arm, g=graviton)"
  default     = "r6g.medium" # 1vcpu, 4GB memory
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

# ----------------------------------------------
# Additional naming context with:
# https://github.com/cloudposse/terraform-null-label
# ----------------------------------------------

variable "namespace" {
  type        = string
  default     = null
  description = "Namespace, which could be your organization name or abbreviation, e.g. 'eg' or 'cp'"
}

variable "environment" {
  type        = string
  default     = null
  description = "Environment, e.g. 'uw2', 'us-west-2', OR 'prod', 'staging', 'dev', 'UAT'"
}

variable "stage" {
  type        = string
  default     = null
  description = "Stage, e.g. 'prod', 'staging', 'dev', OR 'source', 'build', 'test', 'deploy', 'release'"
}

variable "name" {
  type        = string
  default     = null
  description = "Solution name, e.g. 'app' or 'jenkins'"
}

variable "delimiter" {
  type        = string
  default     = null
  description = <<-EOT
    Delimiter to be used between `namespace`, `environment`, `stage`, `name` and `attributes`.
    Defaults to `-` (hyphen). Set to `""` to use no delimiter at all.
  EOT
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags (e.g. `map('BusinessUnit','XYZ')`"
}
