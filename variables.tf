
# Conditionals 

variable "create_iam_policy" {
  type        = bool
  default     = true
  description = "Creates an usable IAM policy for Terraform remote state execution"
}

variable "enable_customer_kms" {
  type        = bool
  default     = false
  description = "Enable server-side encryption with KMS"
}

variable "enable_lifecycle_rules" {
  type        = bool
  default     = false
  description = "Enable bucket lifecycle rules"
}

variable "enable_deletion_protection" {
  type        = bool
  default     = false
  description = "A boolean that indicates all buckets and tables should be protected from accidental deletion."
}

variable "enable_table_encryption" {
  type        = bool
  default     = false
  description = "Enable server-side encryption for the DynamoDB table"
}

# Values 

variable "name" {
  type        = string
  description = "The name of the bucket"
}

variable "iam_policy_name" {
  type        = string
  default     = null
  description = "The name of the IAM policy to create"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to apply to all resources"
}
