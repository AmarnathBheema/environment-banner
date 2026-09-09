output "bucket_id" {
  description = "S3 bucket ID"
  value       = aws_s3_bucket.site.id
}

output "bucket_name" {
  description = "S3 bucket name"
  value       = aws_s3_bucket.site.bucket
}

output "bucket_arn" {
  description = "S3 bucket ARN"
  value       = aws_s3_bucket.site.arn
}

output "bucket_regional_domain_name" {
  description = "S3 regional domain name"
  value       = aws_s3_bucket.site.bucket_regional_domain_name
}