
############################################################
# Creates an IAM Policy for Terraform remote state exeuction
# this policy can be attached to an IAM role.
############################################################


data "aws_iam_policy_document" "default" {
  count = var.create_iam_policy ? 1 : 0
  statement {
    sid = "AllowListBuckets"
    actions = [
      "s3:ListBucket",
      "s3:GetBucketVersioning"
    ]
    effect = "Allow"
    resources = [
      local.bucket_arn
    ]
  }
  statement {
    sid = "AllowBucketObjects"
    actions = [
      "s3:GetObject",
      "s3:PutObject"
    ]
    effect = "Allow"
    resources = [
      format("%s/*", local.bucket_arn)
    ]
  }
  statement {
    sid = "AllowTable"
    actions = [
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:DeleteItem",
      "dynamodb:DescribeTable"
    ]
    effect = "Allow"
    resources = [
      local.dynamodb_table_arn
    ]
  }
  statement {
    sid = "AllowKMS"
    actions = [
      "kms:ListKeys"
    ]
    effect    = "Allow"
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "kms" {
  count = var.create_iam_policy && var.enable_customer_kms ? 1 : 0
  statement {
    sid = "AllowKMSKeyUsage"
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:DescribeKey",
      "kms:GenerateDataKey"
    ]
    effect = "Allow"
    resources = [
      aws_kms_key.kms[0].arn
    ]
  }
}

# Use to combine the default and KMS policy documents into a single policy
data "aws_iam_policy_document" "merged" {
  count = var.create_iam_policy ? 1 : 0
  source_policy_documents = [
    data.aws_iam_policy_document.default[0].json,
    # If KMS is enabled, include the KMS policy document
    try(data.aws_iam_policy_document.kms[0].json, "")
  ]
}

resource "aws_iam_policy" "default" {
  count = var.create_iam_policy ? 1 : 0

  name   = var.iam_policy_name != null ? var.iam_policy_name : format("%s-policy", var.name)
  policy = data.aws_iam_policy_document.merged[0].json

  tags = var.tags
}