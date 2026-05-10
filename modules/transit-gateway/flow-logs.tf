resource "aws_cloudwatch_log_group" "tgw_flow_logs" {
  count             = var.transit_gateway_config.flow_logs_enabled ? 1 : 0
  name              = "/aws/tgw/${local.name_prefix}-flow-logs"
  retention_in_days = 30

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-tgw-flow-logs"
  })
}

resource "aws_iam_role" "tgw_flow_logs" {
  count = var.transit_gateway_config.flow_logs_enabled ? 1 : 0
  name  = "${local.name_prefix}-tgw-flow-logs-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "vpc-flow-logs.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })

  tags = local.common_tags
}

resource "aws_iam_role_policy" "tgw_flow_logs" {
  count  = var.transit_gateway_config.flow_logs_enabled ? 1 : 0
  name   = "${local.name_prefix}-tgw-flow-logs-policy"
  role   = aws_iam_role.tgw_flow_logs[0].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ]
      Resource = "*"
    }]
  })
}

resource "aws_flow_log" "tgw" {
  count                = var.transit_gateway_config.flow_logs_enabled ? 1 : 0
  transit_gateway_id   = aws_ec2_transit_gateway.main.id
  iam_role_arn         = aws_iam_role.tgw_flow_logs[0].arn
  log_destination      = aws_cloudwatch_log_group.tgw_flow_logs[0].arn
  log_destination_type = "cloud-watch-logs"

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-tgw-flow-log"
  })
}
