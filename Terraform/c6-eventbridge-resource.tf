# EventBridge Rule for Scheduled Execution
resource "aws_cloudwatch_event_rule" "schedule" {
  name                = "file_processor_schedule"
  description         = "Schedule for Lambda Function"
  schedule_expression = var.schedule_expression
}

# EventBridge Target
resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.schedule.name
  target_id = "FileProcessorLambda"
  arn       = aws_lambda_function.file_processor.arn
}

# Lambda Permission for EventBridge
resource "aws_lambda_permission" "with_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.file_processor.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.schedule.arn
}

# Get current AWS account ID
data "aws_caller_identity" "current" {}