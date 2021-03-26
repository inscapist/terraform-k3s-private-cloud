resource "aws_autoscaling_group" "node_pool" {
  name_prefix = local.cluster_id

  desired_capacity          = local.node_count
  min_size                  = local.node_count
  max_size                  = local.node_count
  default_cooldown          = local.asg_default_cooldown
  health_check_grace_period = local.asg_health_check_grace_period

  # network
  vpc_zone_identifier = local.private_subnets

  # template
  mixed_instances_policy {
    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.node_pool.id
        version            = local.asg_launch_template_version
      }

      dynamic "override" {
        for_each = local.asg_equiv_instance_types
        content {
          instance_type = override.value
        }
      }
    }

    # Refer following doc for more parameters
    # https://docs.aws.amazon.com/autoscaling/ec2/APIReference/API_InstancesDistribution.html
    instances_distribution {
      on_demand_percentage_above_base_capacity = local.asg_on_demand_percentage
    }
  }

  target_group_arns = local.asg_target_group_arns

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [tag]
  }

  dynamic "tag" {
    for_each = local.node_pool_tags

    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}

resource "aws_launch_template" "node_pool" {
  name_prefix = local.cluster_id
  image_id    = local.node_ami
  user_data   = data.cloudinit_config.k3s_node.rendered

  iam_instance_profile {
    arn = aws_iam_instance_profile.k3s_node.arn
  }

  instance_type = local.asg_base_instance_type

  block_device_mappings {
    device_name = local.node_root_device_name
    ebs {
      volume_size = local.node_vol
      encrypted   = true
    }
  }

  network_interfaces {
    associate_public_ip_address = false
    security_groups = concat([
      aws_security_group.self.id,
      aws_security_group.node_ports.id,
      aws_security_group.egress.id
    ], var.extra_node_security_groups)
  }

  tags = {
    Cluster = local.cluster_id
  }

  lifecycle {
    create_before_destroy = true
  }
}
