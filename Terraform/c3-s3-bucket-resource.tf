# Random string for unique bucket name
resource "random_string" "bucket_suffix" {
  length  = var.random_string_length
  special = false
  upper   = false
}

# S3 Bucket
resource "aws_s3_bucket" "file_upload_bucket" {
  bucket = "file-upload-bucket-${random_string.bucket_suffix.result}"
}

# Enable versioning (optional but recommended)
resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = aws_s3_bucket.file_upload_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# S3 Bucket Notification
resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.file_upload_bucket.id

  topic {
    topic_arn = aws_sns_topic.file_upload_notification.arn
    events    = ["s3:ObjectCreated:*"]
  }
}