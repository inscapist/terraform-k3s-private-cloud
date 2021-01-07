# A role has 1 or many policies
# An instance profile has 1 role
#
# (Role + Policy) is bound together by role_policy_attachment

resource "aws_iam_role" "k3s_master_role" {
  name               = "k3s_master_role-${var.cluster_name}"
  path               = "/"
  assume_role_policy = module.iam_policies.ec2_assume_role
}

resource "aws_iam_instance_profile" "k3s_master_profile" {
  name = "k3s_master_instance_profile-${var.cluster_name}"
  role = aws_iam_role.k3s_master_role.name
}

resource "aws_iam_role_policy_attachment" "k3s_master_cloud_provider" {
  role       = aws_iam_role.k3s_master_role.name
  policy_arn = module.iam_policies.k8s_master_full_arn
}


resource "aws_iam_role_policy_attachment" "k3s_master_session_manager" {
  role       = aws_iam_role.k3s_master_role.name
  policy_arn = module.iam_policies.session_manager_arn
}
