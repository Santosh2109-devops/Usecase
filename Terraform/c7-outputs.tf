# Output the bucket name
output "bucket_name" {
  value = aws_s3_bucket.file_upload_bucket.id
  description = "The name of the created S3 bucket"
}

# Output the SNS topic ARN
output "sns_topic_arn" {
  value = aws_sns_topic.file_upload_notification.arn
  description = "The ARN of the SNS topic"
}