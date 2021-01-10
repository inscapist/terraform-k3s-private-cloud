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

To run this module, simply

1. Select the VPC that you wish to deploy k3s in
2. Carve out a subnet of the VPC to deploy this in, subnet with 1000 host addr is usually enough
3. Specify `cidr_block` of said subnet, which will be further split into public/private subnets
4. Specify availability zone(s) to create subnets in. Total subnets created will be 2 x numOfAZs
5. Enable either nat gateway (defacto, but more expensive) or nat instance (cheaper)

If you don't need egress connectivity for cluster, then you can use the [VPC endpoints for SSM](./extras/ssm_vpc_endpoints). Otherwise, session manager would not work

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
2. gossm start
