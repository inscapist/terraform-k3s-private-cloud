# User data

## Cloud Provider AWS

Manifest is pulled from the [official documentation](https://kubernetes.github.io/cloud-provider-aws/getting_started.html).

Also, refer to the discussion [here](https://github.com/k3s-io/k3s/issues/1807) and [here](https://github.com/kubernetes/cloud-provider-aws/issues/86).

## Cloud Init

We use user data to provision the instance at launch.

More information on how to customize startup scripts can be found in [here](https://cloudinit.readthedocs.io/en/latest/topics/examples.html).

## K3S Installation

We run shell scripts to install K3S.

Related documentations can be found here:

- [Server config](https://rancher.com/docs/k3s/latest/en/installation/install-options/server-config/#commonly-used-options)
- [Agent config](https://rancher.com/docs/k3s/latest/en/installation/install-options/agent-config/)
- [Flags and Environment Variables](https://rancher.com/docs/k3s/latest/en/installation/install-options/how-to-flags/)

Syntax of `templatefile` can be found [here](https://www.terraform.io/docs/configuration/functions/templatefile.html)
