module "s3_bucket" {
  source = "../module"

  bucket_name     = var.bucket_name
  versioning      = var.enable_versioning
  encryption_type = var.encryption_type
  kms_key_arn     = var.kms_key_arn
  lifecycle_rules = var.lifecycle_rules
  enable_logging  = var.enable_logging

  tags = var.tags
}
