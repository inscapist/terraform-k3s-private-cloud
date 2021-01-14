output "ec2_assume_role" {
  value       = data.aws_iam_policy_document.ec2_assume_role_policy.json
  description = "Policy document for EC2 assume role policy"
}

output "k8s_master_full_arn" {
  value       = aws_iam_policy.k8s_master_full.arn
  description = "Policy ARN to apply k8s cloud provider"
}

output "k8s_node_full_arn" {
  value       = aws_iam_policy.k8s_node_full.arn
  description = "Policy ARN to apply k8s node permission (full)"
}

output "k8s_node_minimal_arn" {
  value       = aws_iam_policy.k8s_node_minimal.arn
  description = "Policy ARN to apply k8s node permission (minimal)"
}

output "session_manager_arn" {
  value       = data.aws_iam_policy.ssm.arn
  description = "Policy ARN to enable SessionManager"
}
