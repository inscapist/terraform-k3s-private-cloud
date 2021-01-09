# A role has 1 or many policies
# An instance profile has 1 role
#
# (Role + Policy) is bound together by role_policy_attachment

resource "aws_iam_role" "k3s_master" {
  name               = "k3s_master_role-${local.name}"
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
  name = "k3s_master_instance_profile-${local.name}"
  role = aws_iam_role.k3s_master.name
}

resource "aws_instance" "k3s_master" {
  count                       = local.master_count
  ami                         = local.master_ami
  instance_type               = var.master_instance_type
  subnet_id                   = local.public_subnets[0]
  iam_instance_profile        = aws_iam_instance_profile.k3s_master.name
  associate_public_ip_address = true
  vpc_security_group_ids = concat([
    aws_security_group.self.id,
    aws_security_group.egress.id
  ], var.extra_master_security_groups)

  root_block_device {
    volume_size = local.master_vol
    encrypted   = true
  }

  # user_data = var.user_data # TODO
  tags = {
    Name       = "${local.name}-master"
    K3sCluster = local.name
    K3sRole    = "master"
  }

  lifecycle {
    ignore_changes = [
      ami,       # new ami changes by amazon should not affect change to this instance
      user_data, # https://github.com/hashicorp/terraform-provider-aws/issues/4954
    ]
  }
}
