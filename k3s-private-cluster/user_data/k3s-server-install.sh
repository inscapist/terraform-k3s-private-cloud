#!/bin/bash -x
exec >/tmp/k3s-server-install-debug.log 2>&1

export INSTALL_K3S_NAME="${cluster_id}"
export K3S_TOKEN="${cluster_token}"
export K3S_KUBECONFIG_MODE="644"

provider_id="$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)/$(curl -s http://169.254.169.254/latest/meta-data/instance-id)"

curl -sfL https://get.k3s.io | sh -s - server \
	--disable-cloud-controller \
	--disable servicelb \
	--disable local-storage \
	--disable traefik \
	--node-name="$(hostname -f)" \
	--kubelet-arg="cloud-provider=external" \
	--kubelet-arg="provider-id=aws:///$${provider_id}"

unset INSTALL_K3S_NAME
unset K3S_TOKEN
unset K3S_KUBECONFIG_MODE

echo "K3S Installation successful"
