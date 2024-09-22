data "aws_iam_policy_document" "bucket_force_ssl" {
  statement {
    sid     = "AllowSSLRequestsOnly"
    actions = ["s3:*"]
    effect  = "Deny"
    resources = [
      aws_s3_bucket.default.arn,
      "${aws_s3_bucket.default.arn}/*"
    ]
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }
}

resource "aws_s3_bucket_policy" "bucket_force_ssl" {
  bucket = aws_s3_bucket.default.id
  policy = data.aws_iam_policy_document.bucket_force_ssl.json

  depends_on = [aws_s3_bucket_public_access_block.default]
}

resource "aws_s3_bucket" "default" {
  bucket        = var.name
  force_destroy = local.bucket_force_destroy

  tags = var.tags
}

resource "aws_s3_bucket_ownership_controls" "default" {
  bucket = aws_s3_bucket.default.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}


resource "aws_s3_bucket_acl" "default" {
  depends_on = [aws_s3_bucket_ownership_controls.default]
  bucket     = aws_s3_bucket.default.id
  acl        = "private"
}

resource "aws_s3_bucket_versioning" "default" {
  bucket = aws_s3_bucket.default.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
  count  = var.enable_customer_kms ? 0 : 1
  bucket = aws_s3_bucket.default.id

  # When no AWS KMS key ARN is specified, S3 uses the aws/s3 KMS key.
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "kms" {
  count  = var.enable_customer_kms ? 1 : 0
  bucket = aws_s3_bucket.default.id

  # The default aws/s3 AWS KMS master key is used if no KMS key is specified
  # if we rather want to support custom KMS key, consider adding a conditional resource block, 
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.kms[0].arn
    }
  }
}

resource "aws_s3_bucket_public_access_block" "default" {
  bucket                  = aws_s3_bucket.default.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# # Configure the bucket lifecycle rules
# resource "aws_s3_bucket_lifecycle_configuration" "default" {
#   count  = local.enable_lifecycle_rules ? 1 : 0
#   bucket = aws_s3_bucket.default.id

#   rule {
#     id     = "auto-archive"
#     status = "Enabled"

#     dynamic "noncurrent_version_transition" {
#       for_each = var.noncurrent_version_transitions

#       content {
#         noncurrent_days = noncurrent_version_transition.value.days
#         storage_class   = noncurrent_version_transition.value.storage_class
#       }
#     }

#     dynamic "noncurrent_version_expiration" {
#       for_each = var.noncurrent_version_expiration != null ? [var.noncurrent_version_expiration] : []

#       content {
#         noncurrent_days = noncurrent_version_expiration.value.days
#       }
#     }
#   }
# }