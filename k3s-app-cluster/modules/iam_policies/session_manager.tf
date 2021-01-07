# We only need the Session Manager
#
# Refer here for more managed polcies:
# https://aws.amazon.com/blogs/mt/applying-managed-instance-policy-best-practices/
data "aws_iam_policy" "ssm" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
