resource "aws_iam_policy" "cloudwatch_exporter_policy" {
  name   = "${var.task_role_name}-cloudwatch-exporter-policy"
  policy = data.aws_iam_policy_document.cloudwatch_exporter_policy.json
}

data "aws_iam_policy_document" "cloudwatch_exporter_policy" {
  statement {
    effect = "Allow"
    actions = [
      "cloudwatch:ListMetrics",
      "cloudwatch:GetMetricData",
      "cloudwatch:GetMetricStatistics",
      "tag:GetResources"
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "logs:DescribeLogGroups",
      "logs:GetLogEvents"
    ]
    resources = ["arn:aws:logs:${var.region}:${local.account_id}:log-group:*"]
  }
}

resource "aws_iam_role_policy_attachment" "cloudwatch_exporter_policy_attachment" {
  role       = var.task_role_name
  policy_arn = aws_iam_policy.cloudwatch_exporter_policy.arn
}