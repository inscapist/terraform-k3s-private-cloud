# K3s Private Cluster

## Requirements

| Name      | Version      |
| --------- | ------------ |
| terraform | >= 0.14      |
| SSM Agent | >= 3.0.161.0 |

You need to install:

- terraform
- aws-cli and done `aws configure`

## How to use this?

1. Refer or select one of the [examples](./examples)
2. Run `terraform init` and `terraform apply`
3. Customize the module by referring to [variables.tf](./variables.tf)
4. Access the master instance with GoSSM or via AWS console
5. Test `kubectl` and install additional `helm charts`

It is also recommended to use a backend to persist state information. Read [here](https://www.terraform.io/docs/backends/types/s3.html)

## Networking

This module is designed for workload that runs within private subnet. A private subnet is simply a subnet not associated with an internet gateway.

If you don't need egress connectivity for cluster, you can use the [VPC endpoints for SSM](./extras/ssm_vpc_endpoints). Otherwise, session manager would not work.

Simply specify an unused `cidr_block`, and this module will dynamically create public and private subnets within this block. You _do not_ need to manage subnets.

### Existing VPC

To run this module, simply

1. Select the VPC that you wish to deploy k3s in
2. Carve out a subnet of the VPC to deploy this in, a subnet with 1000 host addresses is usually enough
3. Specify `cidr_block` of said subnet, which will be managed by this module
4. Specify availability zone(s) to create subnets in. Total subnets created will be 2 times number-of-AZs
5. Enable either nat gateway (defacto, but more expensive) or nat instance (cheaper)

Refer [example](./examples/k3s-in-existing-vpc).

### New VPC

Refer [example](./examples/k3s-in-new-vpc).

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

## Debug Kubernetes API

Run `kubectl` with `-A -v=10`, where -A refers to "--all-namespaces" and -v=10 refers to log level

## Access

#### Connect to instances with GoSSM

1. Install [gossm](https://github.com/gjbae1212/gossm)
2. Enter shell with `gossm start`
3. Run `source /usr/bin/aliases`
4. Check that kubernetes is running with `kubectl get all --all-namespaces`

Optionally, if you want to use [kubectl aliases](./user_data/env/kubectl_aliases), add `source ~/.bashrc` to SSM Document/Preference. Refer [this](https://docs.aws.amazon.com/systems-manager/latest/userguide/session-preferences-shell-config.html) for more information.

## Helm charts

#### Fetch and inspect charts

helm fetch CHART --untar

#### Apply chart

Helm 3 is preinstalled. Just run:

```sh
helm \
  --kubeconfig /etc/rancher/k3s/k3s.yaml \
  install MyChart
  # your own set flags or -f values.yaml
```

If you have already ran `source /usr/bin/aliases`, then you don't need to specify `--kubeconfig` flag.

## Recreate with Terraform Taint

To recreate EC2 instances, first taint it then run `terraform apply`. This is preferrable to mutating ec2 instances in-place

```sh
# find the module from state
terraform state list

# then, as an example,
terraform taint "module.k3s-in-existing-vpc.aws_instance.k3s_node[0]"
terraform taint "module.k3s-in-existing-vpc.aws_instance.k3s_node[1]"
terraform taint "module.k3s-in-existing-vpc.aws_instance.k3s_node[2]"

# apply changes
terraform apply
```

## Potential Issues

If you see issues such as "standard_init_linux.go:178: exec user process caused “exec format error”", it may be that the OCI(docker) image is not compiled in the correct architecture:

https://stackoverflow.com/questions/42494853/standard-init-linux-go178-exec-user-process-caused-exec-format-error
