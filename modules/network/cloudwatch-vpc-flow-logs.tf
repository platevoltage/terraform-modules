resource "aws_cloudwatch_log_group" "vpc_flow" {
  name              = "/aws/vpc/flow-logs/${local.name_prefix}"
  retention_in_days = 365
  kms_key_id        = aws_kms_key.cloudwatch_logs.arn

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-vpc-flow"
  })
}
