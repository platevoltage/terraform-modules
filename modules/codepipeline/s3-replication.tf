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
  provider                 = aws.replica
  bucket                   = aws_s3_bucket.codepipeline_bucket_replica.id
  block_public_acls        = true
  block_public_policy      = true
  ignore_public_acls       = true
  restrict_public_buckets  = true
}

# KMS default encryption for replica bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "codepipeline_bucket_replica" {
  provider = aws.replica
  bucket   = aws_s3_bucket.codepipeline_bucket_replica.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = data.aws_kms_alias.s3kmskey_replica.target_key_arn
    }
    bucket_key_enabled = true
  }
}

# Replication role assume policy
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

# Allow S3 replication plus KMS for source and destination
data "aws_iam_policy_document" "replication_policy" {
  # S3 read from source
  statement {
    effect    = "Allow"
    actions   = ["s3:GetReplicationConfiguration", "s3:ListBucket"]
    resources = [aws_s3_bucket.codepipeline_bucket.arn]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:GetObjectVersion",
      "s3:GetObjectVersionAcl",
      "s3:GetObjectVersionForReplication",
      "s3:GetObjectLegalHold",
      "s3:GetObjectVersionTagging",
      "s3:ObjectOwnerOverrideToBucketOwner"
    ]
    resources = ["${aws_s3_bucket.codepipeline_bucket.arn}/*"]
  }

  # S3 write to destination
  statement {
    effect = "Allow"
    actions = [
      "s3:ReplicateObject",
      "s3:ReplicateDelete",
      "s3:ReplicateTags",
      "s3:ObjectOwnerOverrideToBucketOwner"
    ]
    resources = ["${aws_s3_bucket.codepipeline_bucket_replica.arn}/*"]
  }

  # KMS on source key
  statement {
    effect    = "Allow"
    actions   = ["kms:Decrypt", "kms:DescribeKey"]
    resources = [data.aws_kms_alias.s3kmskey.target_key_arn]
  }

  # KMS on destination key
  statement {
    effect    = "Allow"
    actions   = ["kms:Encrypt", "kms:ReEncrypt*", "kms:DescribeKey", "kms:GenerateDataKey*"]
    resources = [data.aws_kms_alias.s3kmskey_replica.target_key_arn]
  }
}

resource "aws_iam_role_policy" "replication" {
  role   = aws_iam_role.replication.id
  policy = data.aws_iam_policy_document.replication_policy.json
}

# Enable versioning on the replica bucket
resource "aws_s3_bucket_versioning" "codepipeline_bucket_replica" {
  provider = aws.replica
  bucket   = aws_s3_bucket.codepipeline_bucket_replica.id
  versioning_configuration {
    status     = "Enabled"
    mfa_delete = "Disabled"
  }
  lifecycle { ignore_changes = [versioning_configuration[0].mfa_delete] }
}

# Replication configuration
resource "aws_s3_bucket_replication_configuration" "codepipeline_bucket" {
  bucket = aws_s3_bucket.codepipeline_bucket.id
  role   = aws_iam_role.replication.arn

  rule {
    id     = "replicate-all"
    status = "Enabled"

    delete_marker_replication { status = "Enabled" }
    filter { prefix = "" }

    # Required when destination uses EncryptionConfiguration
    source_selection_criteria {
      sse_kms_encrypted_objects { status = "Enabled" }
    }

    destination {
      bucket        = aws_s3_bucket.codepipeline_bucket_replica.arn
      storage_class = "STANDARD"

      encryption_configuration {
        replica_kms_key_id = data.aws_kms_alias.s3kmskey_replica.target_key_arn
      }
    }
  }

  depends_on = [
    aws_s3_bucket_versioning.codepipeline_bucket,
    aws_s3_bucket_versioning.codepipeline_bucket_replica,
    aws_s3_bucket_public_access_block.codepipeline_bucket,
    aws_s3_bucket_public_access_block.codepipeline_bucket_replica
  ]
}
