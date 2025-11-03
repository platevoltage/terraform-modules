output "policy_arn" {
  description = "ARN of the CloudWatch exporter IAM policy"
  value       = aws_iam_policy.cloudwatch_exporter_policy.arn
}

output "policy_name" {
  description = "Name of the CloudWatch exporter IAM policy"
  value       = aws_iam_policy.cloudwatch_exporter_policy.name
}