# s3-replication.tf
resource "aws_s3_bucket" "codepipeline_bucket_replica" {
  provider = aws.replica
  bucket   = "${local.task_name}-codepipeline-replica"
  tags     = local.common_tags
}

resource "aws_s3_bucket_ownership_controls" "codepipeline_bucket_replica" {
  provider = aws.replica
  bucket   = aws_s3_bucket.codepipeline_bucket_replica.id
  rule { object_ownership = "BucketOwnerEnforced" }
}

resource "aws_s3_bucket_public_access_block" "codepipeline_bucket_replica" {
  provider               = aws.replica
  bucket                 = aws_s3_bucket.codepipeline_bucket_replica.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "codepipeline_bucket_replica" {
  provider = aws.replica
  bucket   = aws_s3_bucket.codepipeline_bucket_replica.id
  rule {
    apply_server_side_encryption_by_default { sse_algorithm = "AES256" }
    bucket_key_enabled = true
  }
}

# IAM role for replication
data "aws_iam_policy_document" "replication_assume" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}


resource "aws_iam_role" "replication" {
  name               = "${local.task_name}-s3-replication-role"
  assume_role_policy = data.aws_iam_policy_document.replication_assume.json
}

data "aws_iam_policy_document" "replication_policy" {
  statement {
    effect = "Allow"
    actions = ["s3:GetReplicationConfiguration", "s3:ListBucket"]
    resources = [aws_s3_bucket.codepipeline_bucket.arn]
  }
  statement {
    effect = "Allow"
    actions = ["s3:GetObjectVersion", "s3:GetObjectVersionAcl", "s3:GetObjectVersionForReplication", "s3:GetObjectLegalHold", "s3:GetObjectVersionTagging", "s3:ObjectOwnerOverrideToBucketOwner"]
    resources = ["${aws_s3_bucket.codepipeline_bucket.arn}/*"]
  }
  statement {
    effect = "Allow"
    actions = ["s3:ReplicateObject", "s3:ReplicateDelete", "s3:ReplicateTags", "s3:ObjectOwnerOverrideToBucketOwner"]
    resources = ["${aws_s3_bucket.codepipeline_bucket_replica.arn}/*"]
  }
}

resource "aws_iam_role_policy" "replication" {
  role   = aws_iam_role.replication.id
  policy = data.aws_iam_policy_document.replication_policy.json
}

resource "aws_s3_bucket_replication_configuration" "codepipeline_bucket" {
  bucket = aws_s3_bucket.codepipeline_bucket.id
  role   = aws_iam_role.replication.arn

  rule {
    id     = "replicate-all"
    status = "Enabled"

    # v2 schema requires this block
    delete_marker_replication {
      status = "Enabled"  # or "Disabled" if you do not want delete marker replication
    }

    filter { prefix = "" }

    destination {
      bucket        = aws_s3_bucket.codepipeline_bucket_replica.arn
      storage_class = "STANDARD"
      # account = local.account_id  # only for cross-account
    }
  }

  depends_on = [
    aws_s3_bucket_versioning.codepipeline_bucket,
    aws_s3_bucket_versioning.codepipeline_bucket_replica,
    aws_s3_bucket_public_access_block.codepipeline_bucket,
    aws_s3_bucket_public_access_block.codepipeline_bucket_replica
  ]
}


# Enable versioning on the replica bucket
resource "aws_s3_bucket_versioning" "codepipeline_bucket_replica" {
  provider = aws.replica
  bucket   = aws_s3_bucket.codepipeline_bucket_replica.id

  versioning_configuration {
    status     = "Enabled"
    mfa_delete = "Disabled"
  }

  lifecycle {
    ignore_changes = [versioning_configuration[0].mfa_delete]
  }
}

