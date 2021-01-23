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

## Why?

- You are cost-conscious. RDS, Elasticache and EKS are too expensive and perhaps even too complicated
- You want a cluster with low maintenance overhead and just works
- You need a cluster that can be created and destroyed in minutes
- You want to have this cluster for only 1 or 2 apps (App Clusters)
- You want to migrate from legacy infrastructure
- You want to try kubernetes?
- You are a Nix/Terraform person

## Features

- Private cluster with no exposed ports
- Low memory usage and simpler architecture (thanks to K3S)
- It has most expected features of kubernetes (PVC, LoadBalancer, MetricsServer)
- Simple codebase with minimal magic

## What is this?

This module is designed for kubernetes workload that runs within private subnet. A private subnet is simply a subnet not associated with an internet gateway. This results in lower cost and reduction in moving parts, as you do not need to purchase a domain name, certificate and manage perimeter security.

If you don't need egress connectivity for cluster, you can use the [VPC endpoints for SSM](./extras/ssm_vpc_endpoints). Otherwise, session manager would not work.

Various networking configurations are demonstrated in the following examples:

- [New VPC](./examples/k3s-in-new-vpc)
- [Existing VPC, New subnets](./examples/k3s-in-existing-vpc)

## How do I start?

Refer [Getting Started](./docs/getting-started.md) and other [documentation](./docs)
