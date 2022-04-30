# Getting Started

## How do I use this?

1. Refer or select one of the [examples](../examples)
2. Customize the module by referring to their `variables.tf`
3. Access the master instance with GoSSM or via AWS console, or by Port Tunneling `:6443`
4. It is also recommended to use a backend to persist state information. Read [here](https://www.terraform.io/docs/backends/types/s3.html)

### Existing VPC

To run this module, simply

1. Select the VPC that you wish to deploy k3s in
2. Carve out a subnet of the VPC to deploy this in. Ensure the cidr range is unused by other subnets
3. Use `cloudposse/dynamic-subnets` to create new additional subnets. This is a cleaner approach

Refer [example](../examples/k3s-in-existing-vpc).

### New VPC

Refer [example](../examples/k3s-in-new-vpc).

## Access

#### Connect to instances with GoSSM

1. Install [gossm](https://github.com/gjbae1212/gossm)
2. Enter shell with `gossm start`
3. Optionally for convenience, run `source /usr/bin/aliases`, refer [here](../user_data/master/env/aliases)
4. Check that kubernetes is running with `kubectl get all --all-namespaces`

#### Access kubernetes locally

1. [Install](https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html) SSM plugin on your local machine
2. Copy the content of `/etc/rancher/k3s/k3s.yaml` to your local path, eg:

```sh
gossm cmd -e "cat /etc/rancher/k3s/k3s.yaml"

# after seeing a list of instances,
# hit "space" to select master instance, before hitting "enter"
```

3. Find the instance ID with `gossm start`, look for /i-\*/
4. Start a tunnel with:

```sh
aws ssm start-session \
    --target MY_EC2_INSTANCE_ID \
    --document-name AWS-StartPortForwardingSession \
    --parameters '{"portNumber":["6443"], "localPortNumber":["6443"]}'
```

5. Activate the kubeconfig with `export KUBECONFIG="$(pwd)/k3s.yaml"`
6. Access the cluster, eg: `kubectl get all -A`

[![asciicast](https://asciinema.org/a/386844.svg)](https://asciinema.org/a/386844)
