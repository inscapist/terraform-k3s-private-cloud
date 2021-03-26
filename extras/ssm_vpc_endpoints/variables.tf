variable "region" {
  description = "AWS region in which to deploy cluster"
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

