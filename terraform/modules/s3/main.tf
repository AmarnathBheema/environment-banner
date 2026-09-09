resource "aws_s3_bucket" "site" {
  bucket = var.bucket_name

  tags = {
    Name        = var.bucket_name
    Environment = var.environment
    Purpose     = "Static website"
  }
}

resource "aws_s3_bucket_versioning" "site" {
  bucket = aws_s3_bucket.site.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "site" {
  bucket = aws_s3_bucket.site.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_object" "index" {
  bucket = aws_s3_bucket.site.id
  key    = "index.html"

  content = templatefile(
    "${path.module}/templates/index.html.tftpl",
    {
      environment = var.environment
    }
  )

  content_type = "text/html"
}