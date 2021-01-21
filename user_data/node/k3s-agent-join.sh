#!/bin/bash -x
exec >/tmp/k3s-agent-join-debug.log 2>&1

export K3S_TOKEN="${cluster_token}"
export K3S_URL="https://${cluster_server}:6443"

provider_id="$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)/$(curl -s http://169.254.169.254/latest/meta-data/instance-id)"

curl -sfL https://get.k3s.io | sh -s - agent \
	--node-name="$(hostname -f)" \
	--kubelet-arg="cloud-provider=external" \
	--kubelet-arg="provider-id=aws:///$${provider_id}"

unset K3S_TOKEN
unset K3S_URL

echo "K3s Node Join Completed"
