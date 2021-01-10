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

variable "igw_id" {
  type        = string
  description = "Internet Gateway ID the public route table will point to (e.g. `igw-9c26a123`)"
}

variable "cidr_block" {
  # You can use this tool to divide subnets
  # https://network00.com/NetworkTools/IPv4AddressPlanner/
  type        = string
  description = "Base CIDR block which will be divided into subnet CIDR blocks (e.g. `10.0.0.0/16`)"
}

variable "availability_zones" {
  type        = list(string)
  description = "List of Availability Zones where subnets will be created"
}

variable "nat_gateway_enabled" {
  # around $30-50/month, varies by regions
  type        = bool
  description = "Flag to enable/disable NAT Gateways to allow servers in the private subnets to access the Internet"
}

variable "nat_instance_enabled" {
  type        = bool
  description = "Flag to enable/disable NAT Instances to allow servers in the private subnets to access the Internet"
}

variable "nat_instance_type" {
  type        = string
  description = "NAT Instance type"
  default     = "t3.micro" # around $15-18/month, vary by regions
}

variable "nat_elastic_ips" {
  type        = list(string)
  default     = []
  description = "Existing Elastic IPs to attach to the NAT Gateway(s) or Instance(s) instead of creating new ones."
}

# ----------------------------------------------
# Node Instances
# ----------------------------------------------

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
