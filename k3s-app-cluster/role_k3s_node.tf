resource "aws_iam_instance_profile" "k3s_node_profile" {
  name = "k3s_node_instance_profile-${var.cluster_name}"
  role = aws_iam_role.k3s_node_role.name
}

resource "aws_iam_role_policy" "k3s_node_policy" {
  name = "k3s_node_policy-${var.cluster_name}"
  role = aws_iam_role.k3s_node_role.id

  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect":"Allow",
        "Action":[
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
        ],
        "Resource":"*"
      }
    ]
  }
  EOF
}

resource "aws_iam_role" "k3s_node_role" {
  name = "k3s_node_role-${var.cluster_name}"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}
