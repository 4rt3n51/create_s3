variable "bucket_name" {
  description = "Base bucket name supplied by the caller. The module appends the creation date and a random suffix."
  type        = string

  validation {
    condition     = length(trim(replace(lower(var.bucket_name), "/[^a-z0-9-]/", "-"), "-")) > 0
    error_message = "bucket_name must contain at least one letter or number."
  }
}

variable "tags" {
  description = "Additional tags to apply to the bucket."
  type        = map(string)
  default     = {}
}

variable "versioning" {
  description = "Enable S3 versioning."
  type        = bool
  default     = true
}

variable "encryption_type" {
  description = "Encryption type for the bucket."
  type        = string
  default     = "aws:kms"
}

variable "kms_key_arn" {
  description = "Optional ARN of the AWS KMS key to use for S3 server-side encryption. Leave null to use the default AWS-managed S3 KMS key."
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
  description = "Enable S3 logging. Supported values: 'server-access-logging', 'cloudtrail-logging', 'both'. Set to empty string or null to disable."
  type        = string
  default     = "both"
}





