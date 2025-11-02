resource "aws_s3_bucket_server_side_encryption_configuration" "logs" {
  count = var.alb_config.logs_bucket == null ? 0 : 1

  bucket = aws_s3_bucket.logs[0].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "logs" {
  count = var.alb_config.logs_bucket == null ? 0 : 1

  bucket = aws_s3_bucket.logs[0].id

  rule {
    id      = "delete"
    status  = "Enabled"

    expiration {
      days = var.alb_config.logs_expiration
    }
  }
}

resource "aws_s3_bucket_ownership_controls" "logs" {
  count  = var.alb_config.logs_bucket == null ? 0 : 1
  bucket = aws_s3_bucket.logs[0].id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket" "logs" {
  count = var.alb_config.logs_bucket == null ? 0 : 1

  bucket = var.alb_config.logs_bucket

  force_destroy = var.alb_config.logs_bucket_force_destroy

  tags = var.alb_config.common_tags
}

data "aws_iam_policy_document" "alb_logs_s3" {
  count = var.alb_config.logs_bucket == null ? 0 : 1

  statement {
    sid    = "AllowALBLogDeliveryPut"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["logdelivery.elasticloadbalancing.amazonaws.com"]
    }

    actions = ["s3:PutObject"]
    resources = [
      "${aws_s3_bucket.logs[0].arn}/${var.alb_config.logs_prefix}/AWSLogs/${var.alb_config.account_id}/*"
    ]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }

  statement {
    sid    = "AllowALBLogDeliveryGetAcl"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["logdelivery.elasticloadbalancing.amazonaws.com"]
    }

    actions   = ["s3:GetBucketAcl"]
    resources = [aws_s3_bucket.logs[0].arn]
  }
}

resource "aws_s3_bucket_policy" "alb_logs" {
  count = var.alb_config.logs_bucket == null ? 0 : 1

  bucket = aws_s3_bucket.logs[0].id
  policy = data.aws_iam_policy_document.alb_logs_s3[0].json
}

resource "aws_s3_bucket_versioning" "logs" {
  count  = var.alb_config.logs_bucket == null ? 0 : 1
  bucket = aws_s3_bucket.logs[0].id

  versioning_configuration {
    status = "Enabled"

    # Terraform can record this value, but actually turning MFA Delete on
    # requires root credentials with MFA via CLI. See note below.
    mfa_delete = "Disabled" # change to "Enabled" after you enable via CLI
  }

  # Prevent perpetual drift if you enable MFA delete out of band
  lifecycle {
    ignore_changes = [versioning_configuration[0].mfa_delete]
  }
}
