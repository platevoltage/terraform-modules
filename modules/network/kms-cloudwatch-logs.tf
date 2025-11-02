locals {
  kms_region  = var.network_config.aws_region
  kms_account = var.network_config.account_id != "" ? var.network_config.account_id : data.aws_caller_identity.current.account_id
}

resource "aws_kms_key" "cloudwatch_logs" {
  description         = "KMS CMK for CloudWatch Logs encryption"
  enable_key_rotation = true

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid: "EnableRootPermissions",
        Effect: "Allow",
        Principal: { AWS: "arn:aws:iam::${local.kms_account}:root" },
        Action: "kms:*",
        Resource: "*"
      },
      {
        Sid: "AllowCloudWatchLogsUse",
        Effect: "Allow",
        Principal: { Service: "logs.${local.kms_region}.amazonaws.com" },
        Action: [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ],
        Resource: "*",
        Condition: {
          StringEquals: {
            "kms:CallerAccount": "${local.kms_account}",
            "kms:ViaService": "logs.${local.kms_region}.amazonaws.com"
          }
        }
      }
    ]
  })

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-cloudwatch-logs-kms"
  })
}

resource "aws_kms_alias" "cloudwatch_logs" {
  name          = "alias/${local.name_prefix}-cloudwatch-logs"
  target_key_id = aws_kms_key.cloudwatch_logs.key_id
}
