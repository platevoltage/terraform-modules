# Retrieves the AWS account ID at runtime
data "aws_caller_identity" "current" {}

# CMK for SNS topic encryption
resource "aws_kms_key" "sns_topic" {
  description             = "KMS CMK for ${local.task_name}-codepipeline-notify SNS topic"
  deletion_window_in_days = 30
  enable_key_rotation     = true

  # Key policy allows account root and SNS service to use the key
  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Sid: "EnableRootPermissions",
        Effect: "Allow",
        Principal: { AWS: "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root" },
        Action: "kms:*",
        Resource: "*"
      },
      {
        Sid: "AllowSNSToUseKeyForThisTopic",
        Effect: "Allow",
        Principal: { Service: "sns.amazonaws.com" },
        Action: [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey",
          "kms:CreateGrant"
        ],
        Resource: "*",
        Condition: {
          StringEquals: {
            "aws:SourceAccount": "${data.aws_caller_identity.current.account_id}"
          },
          ArnLike: {
              "kms:EncryptionContext:aws:sns:arn": "arn:aws:sns:${local.region}:${data.aws_caller_identity.current.account_id}:${local.task_name}-codepipeline-notify"
          }
        }
      }
    ]
  })

  tags = merge(local.base_config.common_tags, {
    Name = "${local.task_name}-sns-kms"
  })
}

resource "aws_kms_alias" "sns_topic" {
  name          = "alias/${local.task_name}-sns"
  target_key_id = aws_kms_key.sns_topic.key_id
}

# Encrypted SNS topic
resource "aws_sns_topic" "codepipeline_notifications" {
  name               = "${local.task_name}-codepipeline-notify"
  kms_master_key_id  = aws_kms_key.sns_topic.arn
  tags               = local.base_config.common_tags
}

# Allow CodeStar Notifications to publish into the topic
data "aws_iam_policy_document" "sns_topic_policy" {
  statement {
    effect = "Allow"
    actions = ["SNS:Publish"]
    principals {
      type        = "Service"
      identifiers = ["codestar.amazonaws.com"]
    }
    resources = [aws_sns_topic.codepipeline_notifications.arn]
  }
}

resource "aws_sns_topic_policy" "default" {
  arn    = aws_sns_topic.codepipeline_notifications.arn
  policy = data.aws_iam_policy_document.sns_topic_policy.json
}
