data "aws_ami" "amz2-x86_64" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

data "aws_ami" "amz2-arm64" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "architecture"
    values = ["arm64"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

data "aws_vpc" "this" {
  id = var.vpc_id
}


# https://cloudinit.readthedocs.io/en/latest/topics/format.html
data "template_cloudinit_config" "k3s_server" {
  gzip          = true
  base64_encode = true

  # Debug with:
  # cat /var/log/cloud-init.log
  part {
    filename     = "init.cfg"
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/user_data/cloud-config.yaml", {
      # aws_ccm = filebase64("${path.module}/user_data/cloud-provider-aws/aws-ccm.yaml"),
      aws_ccm_ds = filebase64("${path.module}/user_data/cloud-provider-aws/aws-cloud-controller-manager-daemonset.yaml"),
      aws_rbac   = filebase64("${path.module}/user_data/cloud-provider-aws/rbac.yaml")
    })
  }

  # Debug with:
  # cat /tmp/k3s-server-install-debug.log
  # Generated code can be found in /var/lib/cloud/instance/scripts (for debugging purpose)
  part {
    content_type = "text/x-shellscript"
    content = templatefile("${path.module}/user_data/k3s-server-install.sh", {
      cluster_id    = local.cluster_id,
      cluster_token = random_password.cluster_token.result,
    })
  }
}

locals {
  cluster_id   = module.this.id # unique ID from null label
  master_count = 1
  node_count   = 3
  master_ami   = data.aws_ami.amz2-x86_64.id
  node_ami     = var.node_instance_arch == "arm64" ? data.aws_ami.amz2-arm64.id : data.aws_ami.amz2-x86_64.id
  master_vol   = 50
  node_vol     = 50
}
