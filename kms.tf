# When enabled, this module will create a KMS key and an alias for the key.
resource "aws_kms_key" "kms" {
  count                   = var.enable_customer_kms ? 1 : 0
  description             = format("KMS key for remote-state and lock table %s", var.name)
  deletion_window_in_days = 7
  enable_key_rotation     = false

  tags = var.tags
}

resource "aws_kms_alias" "kms" {
  count         = var.enable_customer_kms ? 1 : 0
  name          = "alias/${var.name}"
  target_key_id = aws_kms_key.kms[0].key_id
}
