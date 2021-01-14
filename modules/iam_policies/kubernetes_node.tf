# https://kubernetes.github.io/cloud-provider-aws/prerequisites.html
#
data "aws_iam_policy_document" "k8s_node_full" {
  statement {
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

data "aws_iam_policy_document" "k8s_node_minimal" {
  statement {
    actions = [
      "ec2:DescribeInstances",
      "ec2:DescribeRegions",
    ]

    resources = [
      "*"
    ]
  }
}

resource "aws_iam_policy" "k8s_node_full" {
  policy = data.aws_iam_policy_document.k8s_node_full.json
}

resource "aws_iam_policy" "k8s_node_minimal" {
  policy = data.aws_iam_policy_document.k8s_node_minimal.json
}
