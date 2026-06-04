output "bucket_name" {
  value = aws_s3_bucket.this.bucket
}

output "bucket_arn" {
  value = aws_s3_bucket.this.arn
}

output "logs_bucket_name" {
  value       = try(aws_s3_bucket.logs[0].bucket, null)
  description = "Name of the logging bucket (if logging is enabled)"
}

output "cloudtrail_name" {
  value       = try(aws_cloudtrail.this[0].name, null)
  description = "Name of the CloudTrail trail (if CloudTrail logging is enabled)"
}