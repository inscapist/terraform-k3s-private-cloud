# A role has 1 or many policies
# An instance profile has 1 role
#
# (Role + Policy) is bound together by role_policy_attachment

resource "aws_iam_role" "k3s_master_role" {
  name               = "k3s_master_role-${local.name}"
  path               = "/"
  assume_role_policy = module.iam_policies.ec2_assume_role
}

resource "aws_iam_role_policy_attachment" "k3s_master_cloud_provider" {
  role       = aws_iam_role.k3s_master_role.name
  policy_arn = module.iam_policies.k8s_master_full_arn
}


resource "aws_iam_role_policy_attachment" "k3s_master_session_manager" {
  role       = aws_iam_role.k3s_master_role.name
  policy_arn = module.iam_policies.session_manager_arn
}

resource "aws_iam_instance_profile" "k3s_master_profile" {
  name = "k3s_master_instance_profile-${local.name}"
  role = aws_iam_role.k3s_master_role.name
}

resource "aws_launch_template" "k3s_master" {
  name_prefix   = "${local.name}-master"
  image_id      = local.server_image_id
  instance_type = local.master_instance_type
  user_data     = data.template_cloudinit_config.k3s_server.rendered

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      encrypted   = true
      volume_type = "gp2"
      volume_size = "50"
    }
  }

  network_interfaces {
    delete_on_termination = true
    security_groups       = concat([aws_security_group.self.id, aws_security_group.egress.id], var.extra_master_security_groups)
  }

  tags = {
    Name = "${local.name}-server"
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${local.name}-server"
    }
  }
}

resource "aws_instance" "k3s_master" {
  ami                    = data.aws_ami.ubuntu_focal.id
  instance_type          = var.master_instance_type
  subnet_id              = data.aws_subnet_ids.available[0]
  iam_instance_profile   = aws_iam_instance_profile.k3s_master_profile.name
  vpc_security_group_ids = flatten([aws_security_group.default.id, var.vpc_security_group_ids])

  # user_data = var.user_data # TODO
  tags = { "Name" = local.name }
}
