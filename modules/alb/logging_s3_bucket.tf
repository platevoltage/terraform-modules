# Create the logs bucket only when a name is provided
resource "aws_s3_bucket" "logs" {
  for_each = var.alb_config.logs_bucket != null ? { this = var.alb_config.logs_bucket } : {}
  #checkov:skip=CKV_AWS_144:logs target bucket; replication not required
  bucket        = each.value
  force_destroy = var.alb_config.logs_bucket_force_destroy
  tags          = var.alb_config.common_tags
}

# Enable server access logging on the logs bucket to the access bucket
resource "aws_s3_bucket_logging" "logs" {
  for_each      = aws_s3_bucket.logs
  bucket        = each.value.id
  target_bucket = local.logs_access_bucket_effective
  target_prefix = var.alb_config.logs_access_prefix
}


resource "aws_s3_bucket_ownership_controls" "logs" {
  for_each = aws_s3_bucket.logs
  bucket   = each.value.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "logs" {
  for_each = aws_s3_bucket.logs
  bucket   = each.value.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = coalesce(var.alb_config.logs_kms_key_arn, "aws/s3")
    }
    bucket_key_enabled = true
  }
}

resource "aws_s3_bucket_versioning" "logs" {
  for_each = aws_s3_bucket.logs
  bucket   = each.value.id

  versioning_configuration {
    status     = "Enabled"
    mfa_delete = "Disabled"
  }

  lifecycle {
    ignore_changes = [versioning_configuration[0].mfa_delete]
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "logs" {
  for_each = aws_s3_bucket.logs
  bucket   = each.value.id

  rule {
    id     = "delete"
    status = "Enabled"
    
    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
    
    expiration {
      days = var.alb_config.logs_expiration
    }
  }
}

data "aws_iam_policy_document" "alb_logs_s3" {
  for_each = aws_s3_bucket.logs

  statement {
    sid    = "AllowALBLogDeliveryPut"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["logdelivery.elasticloadbalancing.amazonaws.com"]
    }

    actions   = ["s3:PutObject"]
    resources = ["${each.value.arn}/${var.alb_config.logs_prefix}/AWSLogs/${var.alb_config.account_id}/*"]

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
    resources = [each.value.arn]
  }
}

resource "aws_s3_bucket_policy" "alb_logs" {
  for_each = aws_s3_bucket.logs
  bucket   = each.value.id
  policy   = data.aws_iam_policy_document.alb_logs_s3[each.key].json
}

# Public access block for the ALB logs bucket
resource "aws_s3_bucket_public_access_block" "logs" {
  for_each = aws_s3_bucket.logs
  bucket   = each.value.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Event notifications (via EventBridge) for the ALB logs bucket
resource "aws_s3_bucket_notification" "logs_eventbridge" {
  for_each    = aws_s3_bucket.logs
  bucket      = each.value.id
  eventbridge = true

  depends_on = [
    aws_s3_bucket_ownership_controls.logs[each.key],
    aws_s3_bucket_public_access_block.logs[each.key]
  ]
}

