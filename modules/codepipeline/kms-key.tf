resource "aws_kms_key" "s3kmskey" {
  description             = "KMS key for S3 bucket encryption"
  deletion_window_in_days = 10
  enable_key_rotation     = true

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "EnableRootPermissions"
        Effect   = "Allow"
        Principal = { AWS = "arn:aws:iam::${local.account_id}:root" }
        Action   = "kms:*"
        Resource = "*"
      },
      {
        Sid      = "AllowS3UseForArtifactBucket"
        Effect   = "Allow"
        Principal = { Service = "s3.amazonaws.com" }
        Action   = [
          "kms:Encrypt","kms:Decrypt","kms:ReEncrypt*","kms:GenerateDataKey*","kms:CreateGrant","kms:DescribeKey"
        ]
        Resource  = "*"
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = local.account_id
            "kms:ViaService"    = "s3.${local.region}.amazonaws.com"
          },
          ArnLike = {
            "kms:EncryptionContext:aws:s3:arn" = "arn:aws:s3:::${aws_s3_bucket.codepipeline_bucket.id}/*"
          }
        }
      }
    ]
  })
}

resource "aws_kms_alias" "s3kmskey" {
  name          = "alias/${local.task_name}-kms-key"
  target_key_id = aws_kms_key.s3kmskey.id
}

data "aws_kms_alias" "s3kmskey" {
  name = aws_kms_alias.s3kmskey.name
}