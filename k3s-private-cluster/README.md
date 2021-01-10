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

This module is designed for workload that runs within private subnet. A private subnet is simply a subnet not associated with an internet gateway.

For session manager (think of it as bastion) to work however, a nat instance/gateway is needed.
Example setup can be found in [examples](./examples)

Depending on the use case, there are 2 options to run this:

#### Use an existing VPC

When you do not want to create a new VPC, perhaps because of its overhead.

#### Create a new VPC

For a greenfield project, create a new VPC with either:

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
