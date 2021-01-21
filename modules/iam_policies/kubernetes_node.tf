# https://kubernetes.github.io/cloud-provider-aws/prerequisites.html
#
data "aws_iam_policy_document" "k8s_node_full" {
  statement {
    actions = [
      # Basic
      "ec2:DescribeInstances",
      "ec2:DescribeRegions",

      # Private image
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetRepositoryPolicy",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:BatchGetImage",

      # For EBS CSI Driver
      "ec2:AttachVolume",
      "ec2:CreateSnapshot",
      "ec2:CreateTags",
      "ec2:CreateVolume",
      "ec2:DeleteSnapshot",
      "ec2:DeleteTags",
      "ec2:DeleteVolume",
      "ec2:DescribeInstances",
      "ec2:DescribeSnapshots",
      "ec2:DescribeTags",
      "ec2:DescribeVolumes",
      "ec2:DetachVolume",
      "ec2:ModifyVolume"
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
