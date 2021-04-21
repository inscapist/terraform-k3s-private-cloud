locals {
  cluster_id            = var.cluster_id
  master_count          = 1
  node_count            = var.node_count
  master_ami            = data.aws_ami.amz2-x86_64.id
  node_ami              = var.node_instance_arch == "arm64" ? data.aws_ami.amz2-arm64.id : data.aws_ami.amz2-x86_64.id
  node_root_device_name = var.node_instance_arch == "arm64" ? data.aws_ami.amz2-arm64.root_device_name : data.aws_ami.amz2-x86_64.root_device_name
  master_vol            = 50
  node_vol              = 50
  private_subnets       = var.private_subnets

  # ASG configuration
  asg_launch_template_version   = "$Latest"
  asg_target_group_arns         = var.target_group_arns
  asg_default_cooldown          = 30
  asg_health_check_grace_period = 30
  asg_on_demand_percentage      = var.on_demand_percentage
  asg_base_instance_type        = element(var.node_instance_types, 0)
  asg_equiv_instance_types      = slice(var.node_instance_types, 1, length(var.node_instance_types))
  node_pool_tags = {
    "Name"                                    = "${var.cluster_id}-nodes"
    "KubernetesCluster"                       = var.cluster_id
    "kubernetes.io/cluster/${var.cluster_id}" = "owned"
    "k3s-role"                                = "node"

    # supports cluster autoscaler by default
    "k8s.io/cluster-autoscaler/enabled"           = 1
    "k8s.io/cluster-autoscaler/${var.cluster_id}" = "owned"
  }

}
