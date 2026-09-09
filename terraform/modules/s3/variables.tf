variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string

  validation {
    condition     = contains(["Dev", "Prod"], var.environment)
    error_message = "Environment must be either Dev or Prod."
  }
}