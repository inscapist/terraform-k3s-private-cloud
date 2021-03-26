# A role has 1 or many policies
# An instance profile has 1 role
#
# (Role + Policy) is bound together by role_policy_attachment

resource "aws_iam_role" "k3s_node" {
  name               = "k3s_node_role-${local.cluster_id}"
  path               = "/"
  assume_role_policy = module.iam_policies.ec2_assume_role
}

resource "aws_iam_role_policy_attachment" "k3s_node" {
  role       = aws_iam_role.k3s_node.name
  policy_arn = module.iam_policies.k8s_node_full_arn
}

resource "aws_iam_role_policy_attachment" "k3s_node_session_manager" {
  role       = aws_iam_role.k3s_node.name
  policy_arn = module.iam_policies.session_manager_arn
}

resource "aws_iam_instance_profile" "k3s_node" {
  name = "k3s_node_instance_profile-${local.cluster_id}"
  role = aws_iam_role.k3s_node.name
}

# https://cloudinit.readthedocs.io/en/latest/topics/format.html
data "cloudinit_config" "k3s_node" {
  gzip          = true
  base64_encode = true

  # Debug with:
  # cat /tmp/k3s-agent-join-debug.log
  # Generated code can be found in /var/lib/cloud/instance/scripts (for debugging purpose)
  part {
    content_type = "text/x-shellscript"
    content = templatefile("${path.module}/user_data/node/k3s-agent-join.sh", {
      cluster_id     = local.cluster_id,
      cluster_token  = random_password.cluster_token.result,
      cluster_server = aws_instance.k3s_master.0.private_dns
    })
  }
}


resource "aws_instance" "k3s_node" {
  count                = local.node_count
  ami                  = local.node_ami
  instance_type        = var.node_instance_type
  iam_instance_profile = aws_iam_instance_profile.k3s_node.name

  # spread instances across subnets
  subnet_id                   = element(local.private_subnets, count.index)
  associate_public_ip_address = false

  vpc_security_group_ids = concat([
    aws_security_group.self.id,
    aws_security_group.node_ports.id,
    aws_security_group.egress.id
  ], var.extra_node_security_groups)

  root_block_device {
    volume_size = local.node_vol
    encrypted   = true
  }

  user_data = data.cloudinit_config.k3s_node.rendered

  tags = {
    "KubernetesCluster"                         = local.cluster_id
    "kubernetes.io/cluster/${local.cluster_id}" = "owned"
    "k3s-role"                                  = "node"
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
