variable "region" {
  description = "AWS region where the bucket will be created."
  type        = string
  default     = "eu-central-1"
}

variable "bucket_name" {
  description = "Base bucket name provided by the user. The module appends the creation date and random suffix."
  type        = string
}

variable "tags" {
  description = "Tags to apply to the bucket."
  type        = map(string)
  default = {}
}

variable "enable_versioning" {
  description = "Enable S3 bucket versioning."
  type        = bool
  default     = true
}

variable "encryption_type" {
  description = "S3 encryption type."
  type        = string
  default     = "aws:kms"
}

variable "kms_key_arn" {
  description = "Optional ARN of the AWS KMS key to use for S3 server-side encryption."
  type        = string
  default     = null
}

variable "lifecycle_rules" {
  description = "Lifecycle rules to apply to the bucket."
  type = list(object({
    id      = string
    enabled = optional(bool, true)
    prefix  = optional(string)
    current_transitions = optional(list(object({
      days          = number
      storage_class = string
    })), [])
    expiration_days = optional(number)
    noncurrent_transitions = optional(list(object({
      noncurrent_days = number
      storage_class   = string
    })), [])
    noncurrent_expiration_days             = optional(number)
    abort_incomplete_multipart_upload_days = optional(number)
  }))
  default = [{
    id      = "general-retention"
    enabled = true
    current_transitions = [
      {
        days          = 30
        storage_class = "STANDARD_IA"
      },
      {
        days          = 90
        storage_class = "GLACIER_IR"
      }
    ]
    noncurrent_transitions = [
      {
        noncurrent_days = 30
        storage_class   = "STANDARD_IA"
      }
    ]
    noncurrent_expiration_days             = 180
    abort_incomplete_multipart_upload_days = 7
  }]
}

variable "enable_logging" {
  description = "Enable S3 logging. Supported values: 'server-access-logging', 'cloudtrail-logging', 'both'. Leave empty to disable."
  type        = string
  default     = "both"
}






