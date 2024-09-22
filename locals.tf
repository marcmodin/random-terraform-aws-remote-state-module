locals {
  bucket_arn                       = aws_s3_bucket.default.arn
  bucket_force_destroy             = var.enable_deletion_protection == true ? false : true
  dynamodb_table_arn               = aws_dynamodb_table.default.arn
  lock_key_id                      = "LockID"
  dynamodb_table_name              = format("%s-lock", var.name)
  table_enable_deletion_protection = var.enable_deletion_protection
}