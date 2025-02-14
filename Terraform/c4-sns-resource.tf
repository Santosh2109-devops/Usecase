# SNS Topic
resource "aws_sns_topic" "file_upload_notification" {
  name = "file-upload-notification"
}

# SNS Topic Policy
resource "aws_sns_topic_policy" "default" {
  arn = aws_sns_topic.file_upload_notification.arn

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowS3ToPublishToSNS"
        Effect = "Allow"
        Principal = {
          Service = "s3.amazonaws.com"
        }
        Action   = "SNS:Publish"
        Resource = aws_sns_topic.file_upload_notification.arn
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = data.aws_caller_identity.current.account_id
          }
          ArnLike = {
            "aws:SourceArn" = aws_s3_bucket.file_upload_bucket.arn
          }
        }
      }
    ]
  })
}

# Email Subscription to SNS Topic
resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.file_upload_notification.arn
  protocol  = "email"
  endpoint  = var.notification_email
}