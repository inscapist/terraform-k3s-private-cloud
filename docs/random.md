# Advice

## Debugging

#### Query helpers

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

#### Debug Kubernetes API

Run `kubectl` with `-A -v=10`, where -A refers to "--all-namespaces" and -v=10 refers to log level

## Helm charts

#### Fetch and inspect charts

helm fetch CHART --untar

#### Apply chart (within the instance)

Helm 3 is preinstalled. Just run:

```sh
helm \
  --kubeconfig /etc/rancher/k3s/k3s.yaml \
  install MyChart
  # your own set flags or -f values.yaml
```

If you have already ran `source /usr/bin/aliases`, then you don't need to specify `--kubeconfig` flag.

## Some Terraform Tricks

#### Recreate with Terraform Taint

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

## Common Pitfalls

#### Mismatched Container Architecture

If you see issues such as "standard_init_linux.go:178: exec user process caused “exec format error”", it may be that the OCI(docker) image is not compiled in the correct architecture:

https://stackoverflow.com/questions/42494853/standard-init-linux-go178-exec-user-process-caused-exec-format-error
