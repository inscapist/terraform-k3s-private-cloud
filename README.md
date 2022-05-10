# K3s Private Cluster

[![asciicast](https://asciinema.org/a/386840.svg)](https://asciinema.org/a/386840)

Asciicast for accessing cluster can be viewed [here](./docs/getting-started.md)

## Requirements

| Name      | Version      |
| --------- | ------------ |
| terraform | >= 0.14      |
| SSM Agent | >= 3.0.161.0 |

This module is published at [Terraform registry](https://registry.terraform.io/modules/sagittaros/private-cloud/k3s/latest)

## Why would you want this?

- You are cost-conscious. RDS, Elasticache and EKS are too expensive and perhaps even too complicated
- You want a cluster with low maintenance overhead and just works
- You want to have this cluster for only 1 or 2 apps (App Clusters)

## Why would I do this?

- I wish to empower individual developers to have their own test/staging environment
- Big clusters fail, coordination is hard, service mesh is expensive
- I wish our code can simply run anywhere on any cloud, even if its stateful

## Features

- Private cluster with no exposed ports
- Low memory usage and simpler architecture (thanks to K3S)
- It has most of the expected features of kubernetes (PVC, LoadBalancer, MetricsServer)
- Simple codebase with minimal magic
- Network agnostic with ability to reuse VPC

## What is this?

This module is designed for kubernetes workload that runs within private subnet. A private subnet is simply a subnet not associated with an internet gateway. This results in lower cost and reduction in moving parts, as you do not need to purchase a domain name, certificate and manage perimeter security.

If you don't need egress connectivity for cluster, you can use the [VPC endpoints for SSM](./extras/ssm_vpc_endpoints). Otherwise, session manager would not work.

This module currently supports only AWS cloud. However, I wish to support more clouds with minimal differences between API.

Various networking configurations are demonstrated in the following examples:

- [New VPC](./examples/k3s-in-new-vpc)
- [Existing VPC, New subnets](./examples/k3s-in-existing-vpc)

## How do I start?

Refer [Getting Started](./docs/getting-started.md) and other [documentation](./docs)
