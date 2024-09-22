output "terraform_backend_configuration" {
  value = "\nterraform {\n  backend \"s3\" {\n    bucket  = \"${aws_s3_bucket.default.id}\"\n    key  = \"YOUR VALUE FOR THE REMOTE STATE\"\n    region  = \"${aws_s3_bucket.default.region}\"\n    dynamodb_table = \"${aws_dynamodb_table.default.name}\"\n    encrypt = true \n  }\n}"
}

output "bucket_id" {
  description = "The S3 bucket ID to store the remote state file."
  value       = aws_s3_bucket.default.id
}

output "bucket_arn" {
  description = "The S3 bucket ARN to store the remote state file."
  value       = aws_s3_bucket.default.arn
}

output "dynamodb_table_arn" {
  description = "The DynamoDB table ARN "
  value       = aws_dynamodb_table.default.arn
}

output "dynamodb_table_id" {
  description = "The DynamoDB table ID"
  value       = aws_dynamodb_table.default.id
}

output "iam_policy_arn" {
  description = "The IAM Policy to access remote state environment."
  value       = try(aws_iam_policy.default[0].arn, null)
}

output "kms_key_id" {
  description = "The KMS ID customer master key to encrypt state buckets."
  value       = try(aws_kms_key.kms[0].id, null)
}

output "kms_key_arn" {
  description = "The KMS ARN customer master key to encrypt state buckets."
  value       = try(aws_kms_key.kms[0].arn, null)
}

output "kms_key_alias_arn" {
  description = "The alias ARN of the KMS customer master key used to encrypt state bucket and dynamodb."
  value       = try(aws_kms_alias.kms[0].arn, null)
}
