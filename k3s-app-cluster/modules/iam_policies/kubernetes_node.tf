data "aws_iam_policy_document" "k3s_node_full" {
  # https://kubernetes.github.io/cloud-provider-aws/prerequisites.html
  statement {
    sid    = "K3sNodePolicyFull"
    effect = "Allow"

    actions = [
      "ec2:DescribeInstances",
      "ec2:DescribeRegions",
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetRepositoryPolicy",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:BatchGetImage"
    ]

    resources = [
      "*"
    ]
  }
}

data "aws_iam_policy_document" "k3s_node_minimal" {
  # https://kubernetes.github.io/cloud-provider-aws/prerequisites.html
  statement {
    sid    = "K3sNodePolicyMinimal"
    effect = "Allow"

    actions = [
      "ec2:DescribeInstances",
      "ec2:DescribeRegions",
    ]

    resources = [
      "*"
    ]
  }
}
