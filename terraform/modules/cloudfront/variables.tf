variable "environment" {
  description = "Deployment environment"
  type        = string

  validation {
    condition     = contains(["Dev", "Prod"], var.environment)
    error_message = "Environment must be either Dev or Prod."
  }
}

variable "bucket_id" {
  description = "S3 bucket ID"
  type        = string
}

variable "bucket_arn" {
  description = "S3 bucket ARN"
  type        = string
}

variable "bucket_regional_domain_name" {
  description = "S3 regional domain name"
  type        = string
}