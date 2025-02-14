# IAM Role for Lambda
resource "aws_iam_role" "lambda_role" {
  name = "file_processor_lambda_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# IAM Policy for Lambda
resource "aws_iam_role_policy" "lambda_policy" {
  name = "file_processor_lambda_policy"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:*"
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "sns:Publish"
        ]
        Resource = [
          "${aws_s3_bucket.file_upload_bucket.arn}/*",
          aws_sns_topic.file_upload_notification.arn
        ]
      }
    ]
  })
}

# Lambda Function
resource "aws_lambda_function" "file_processor" {
  filename      = "lambda_function.zip"
  function_name = "file_processor"
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = var.lambda_runtime
  timeout       = var.lambda_timeout

  environment {
    variables = {
      SNS_TOPIC_ARN = aws_sns_topic.file_upload_notification.arn
    }
  }
}

# SNS Topic Subscription to Lambda
resource "aws_sns_topic_subscription" "lambda" {
  topic_arn = aws_sns_topic.file_upload_notification.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.file_processor.arn
}

# Lambda Permission for SNS
resource "aws_lambda_permission" "with_sns" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.file_processor.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.file_upload_notification.arn
}