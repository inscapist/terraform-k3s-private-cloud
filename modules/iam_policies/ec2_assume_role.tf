data "aws_iam_policy_document" "ec2_assume_role_policy" {
  # this is used by aws_iam_role -> assume_role_policy

  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}
