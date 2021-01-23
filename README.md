# K3s Private Cluster

## Requirements

| Name      | Version      |
| --------- | ------------ |
| terraform | >= 0.14      |
| SSM Agent | >= 3.0.161.0 |

You need to install:

- terraform
- aws-cli and done `aws configure`

It is also recommended to use a backend to persist state information. Read [here](https://www.terraform.io/docs/backends/types/s3.html)

## What is this?

This module is designed for kubernetes workload that runs within private subnet. A private subnet is simply a subnet not associated with an internet gateway. This results in lower cost and barrier, as you do not need to purchase a domain name, certificate and manage perimeter security.

If you don't need egress connectivity for cluster, you can use the [VPC endpoints for SSM](./extras/ssm_vpc_endpoints). Otherwise, session manager would not work.

Various networking configurations are demonstrated in the following examples:

- [New VPC](./examples/k3s-in-new-vpc)
- [Existing VPC, New subnets](./examples/k3s-in-existing-vpc)

## How do I start?

Refer [Getting Started](./docs/getting-started.md) and other [documentation](./docs)
