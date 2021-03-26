# A role has 1 or many policies
# An instance profile has 1 role
#
# (Role + Policy) is bound together by role_policy_attachment

resource "aws_iam_role" "k3s_master" {
  name               = "k3s_master_role-${local.cluster_id}"
  path               = "/"
  assume_role_policy = module.iam_policies.ec2_assume_role
}

resource "aws_iam_role_policy_attachment" "k3s_master_cloud_provider" {
  role       = aws_iam_role.k3s_master.name
  policy_arn = module.iam_policies.k8s_master_full_arn
}


resource "aws_iam_role_policy_attachment" "k3s_master_session_manager" {
  role       = aws_iam_role.k3s_master.name
  policy_arn = module.iam_policies.session_manager_arn
}

resource "aws_iam_instance_profile" "k3s_master" {
  name = "k3s_master_instance_profile-${local.cluster_id}"
  role = aws_iam_role.k3s_master.name
}

# https://cloudinit.readthedocs.io/en/latest/topics/format.html
data "cloudinit_config" "k3s_master" {
  gzip          = true
  base64_encode = true

  # Debug with:
  # cat /var/log/cloud-init.log
  part {
    filename     = "init.cfg"
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/user_data/master/cloud-config.yaml", {
      aws_ccm_ds   = filebase64("${path.module}/user_data/master/cloud-provider-aws/aws-cloud-controller-manager-daemonset.yaml"),
      aws_rbac     = filebase64("${path.module}/user_data/master/cloud-provider-aws/rbac.yaml")
      storageclass = filebase64("${path.module}/user_data/master/cloud-provider-aws/storageclass.yaml")
      aliases      = filebase64("${path.module}/user_data/master/env/aliases")
    })
  }

  # Debug with:
  # cat /tmp/k3s-server-install-debug.log
  # Generated code can be found in /var/lib/cloud/instance/scripts (for debugging purpose)
  part {
    content_type = "text/x-shellscript"
    content = templatefile("${path.module}/user_data/master/k3s-server-install.sh", {
      cluster_id    = local.cluster_id,
      cluster_token = random_password.cluster_token.result,
    })
  }
}

resource "aws_instance" "k3s_master" {
  count                = local.master_count
  ami                  = local.master_ami
  instance_type        = var.master_instance_type
  iam_instance_profile = aws_iam_instance_profile.k3s_master.name

  # spread instances across subnets
  subnet_id                   = element(local.private_subnets, count.index)
  associate_public_ip_address = false

  vpc_security_group_ids = concat([
    aws_security_group.self.id,
    aws_security_group.node_ports.id,
    aws_security_group.egress.id
  ], var.extra_master_security_groups)

  root_block_device {
    volume_size = local.master_vol
    encrypted   = true
  }

  user_data = data.cloudinit_config.k3s_master.rendered

  tags = {
    "Name"                                      = "${local.cluster_id}-master",
    "KubernetesCluster"                         = local.cluster_id,
    "kubernetes.io/cluster/${local.cluster_id}" = "owned"
    "k3s-role"                                  = "master"
  }

  lifecycle {
    ignore_changes = [
      ami,       # new ami changes by amazon should not affect change to this instance
      user_data, # https://github.com/hashicorp/terraform-provider-aws/issues/4954
      tags,
      volume_tags,
    ]
  }
}
