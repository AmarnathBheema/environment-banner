terraform {
  backend "s3" {
    bucket = "environment-banner-terraform-state"
    key    = "dev/terraform.tfstate"
    region = "ap-south-1"
    #dynamodb_table = "environment-banner-terraform-locks"
    encrypt = true
  }
}