# MongoDB private cluster

## Networking

This project is agnostic to network configuration, instead requiring only the subnet_ids to be the input. However, because this project uses Session Manager instead of Bastion, egress connectivity is required and Nat-Gateway(s) should be used.

There are several options:

#### Use existing default VPC

To ensure egress connectivity, create a nat gateway using [extras/simple_nat_gateway](./extras/simple_nat_gateway)

#### Create a new VPC

Create a new VPC with either:

- [Terraform AWS VPC](https://github.com/terraform-aws-modules/terraform-aws-vpc)
- [cloudposse's multi-az-subnets](https://github.com/cloudposse/terraform-aws-multi-az-subnets)

## Access

#### Connect with GoSSM

1. Install [gossm](https://github.com/gjbae1212/gossm)
2.
