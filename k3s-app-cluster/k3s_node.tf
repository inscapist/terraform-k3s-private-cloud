# A role has 1 or many policies
# An instance profile has 1 role
#
# (Role + Policy) is bound together by role_policy_attachment

resource "aws_iam_role" "k3s_node_role" {
  name               = "k3s_node_role-${local.name}"
  path               = "/"
  assume_role_policy = module.iam_policies.ec2_assume_role
}

resource "aws_iam_instance_profile" "k3s_node_profile" {
  name = "k3s_node_instance_profile-${local.name}"
  role = aws_iam_role.k3s_node_role.name
}

resource "aws_iam_role_policy_attachment" "k3s_node" {
  role       = aws_iam_role.k3s_node_role.name
  policy_arn = module.iam_policies.k8s_node_minimal_arn
}


resource "aws_iam_role_policy_attachment" "k3s_node_session_manager" {
  role       = aws_iam_role.k3s_node_role.name
  policy_arn = module.iam_policies.session_manager_arn
}
