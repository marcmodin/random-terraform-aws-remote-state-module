
resource "aws_dynamodb_table" "default" {
  name                        = local.dynamodb_table_name
  billing_mode                = "PAY_PER_REQUEST"
  hash_key                    = local.lock_key_id
  deletion_protection_enabled = local.table_enable_deletion_protection

  attribute {
    name = local.lock_key_id
    type = "S"
  }

  #   server_side_encryption {
  #     enabled     = var.enable_customer_kms
  #     kms_key_arn = aws_kms_key.this.arn
  #   }

  dynamic "server_side_encryption" {
    for_each = var.enable_customer_kms ? [1] : []
    content {
      enabled     = var.enable_customer_kms
      kms_key_arn = aws_kms_key.kms[0].arn
    }
  }

  point_in_time_recovery {
    enabled = true
  }

  tags = var.tags
}