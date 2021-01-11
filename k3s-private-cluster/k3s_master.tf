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

module "k3s_master_label" {
  source  = "cloudposse/label/null"
  version = "0.22.1"

  context = module.this.context
  name    = "${local.cluster_id}-k3s-master"
  tags = {
    "KubernetesCluster"                         = local.cluster_id,
    "kubernetes.io/cluster/${local.cluster_id}" = "owned"
  }
}

resource "aws_instance" "k3s_master" {
  count                = local.master_count
  ami                  = local.master_ami
  instance_type        = var.master_instance_type
  iam_instance_profile = aws_iam_instance_profile.k3s_master.name

  subnet_id                   = module.subnets.private_subnet_ids[0]
  associate_public_ip_address = false

  vpc_security_group_ids = concat([
    aws_security_group.self.id,
    aws_security_group.egress.id
  ], var.extra_master_security_groups)

  root_block_device {
    volume_size = local.master_vol
    encrypted   = true
  }

  user_data = data.template_cloudinit_config.k3s_server.rendered
  tags      = module.k3s_master_label.tags

  lifecycle {
    ignore_changes = [
      ami,       # new ami changes by amazon should not affect change to this instance
      user_data, # https://github.com/hashicorp/terraform-provider-aws/issues/4954
    ]
  }
}
