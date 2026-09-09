variable "aws_region" {
  description = "AWS region"
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

variable "bucket_name" {
  description = "Static website S3 bucket name"
  type        = string
}

variable "state_bucket_name" {
  description = "S3 bucket used for Terraform remote state"
  type        = string
}

variable "lock_table_name" {
  description = "DynamoDB table used for Terraform state locking"
  type        = string
}