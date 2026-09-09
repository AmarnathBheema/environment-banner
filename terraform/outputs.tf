output "cloudfront_url" {
  description = "CloudFront URL for the static website"
  value       = module.cloudfront.cloudfront_url
}

output "s3_bucket_name" {
  description = "Static website S3 bucket"
  value       = module.s3.bucket_name
}

output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID"
  value       = module.cloudfront.distribution_id
}

output "state_bucket_name" {
  value = aws_s3_bucket.terraform_state.bucket
}

output "lock_table_name" {
  value = aws_dynamodb_table.terraform_locks.name
}