# K3s Private Cluster

## Requirements

| Name      | Version |
| --------- | ------- |
| terraform | >= 0.14 |

## How to use this?

1. Run `terraform init` and `terraform apply` in one of [examples](./examples)
2. Customize the module by referring to [variables.tf](./variables.tf)
3. Access the master instance with GoSSM or via AWS console
4. Test `kubectl` and install additional `helm charts`

## Networking

This project is agnostic to network configuration, instead requiring only the subnet_ids to be the input. However, because this project uses Session Manager instead of Bastion, egress connectivity is required and Nat-Gateway(s) should be used.

There are several options:

#### Use existing default VPC

Create Nat instance

#### Create a new VPC

Create a new VPC with either:

- [Terraform AWS VPC](https://github.com/terraform-aws-modules/terraform-aws-vpc)
- [cloudposse's multi-az-subnets](https://github.com/cloudposse/terraform-aws-multi-az-subnets)

## Query helpers

Output format is set to "table", but can also be "json", "yaml", "text"

```sh
# Get list of VPCs
aws ec2 describe-vpcs --output=table

# Get list of route tables
aws ec2 describe-route-tables --output=table

# Get subnets
aws ec2 describe-subnets --output=table

# Get internet gateways (At least 1 public subnet is needed)
aws ec2 describe-internet-gateways --output=table
```

## Access

#### Connect to instances with GoSSM

1. Install [gossm](https://github.com/gjbae1212/gossm)
2.
