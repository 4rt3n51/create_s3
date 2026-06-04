output "bucket_name" {
  value = module.s3_bucket.bucket_name
}

output "bucket_arn" {
  value = module.s3_bucket.bucket_arn
}

output "logs_bucket_name" {
  value       = module.s3_bucket.logs_bucket_name
  description = "Name of the logging bucket (if logging is enabled)"
}

output "cloudtrail_name" {
  value       = module.s3_bucket.cloudtrail_name
  description = "Name of the CloudTrail trail (if CloudTrail logging is enabled)"
}