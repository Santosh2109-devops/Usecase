# variables.tf

variable "environment" {
  description = "Environment name for tagging"
  type        = string
  default     = "dev"
}

variable "notification_email" {
  description = "Email address to receive S3 upload notifications"
  type        = string
  default = "santoshpusparaj.surendar@gmail.com"
}

variable "lambda_runtime" {
  description = "Runtime for Lambda function"
  type        = string
  default     = "python3.9"
}

variable "lambda_timeout" {
  description = "Timeout for Lambda function in seconds"
  type        = number
  default     = 30
}

variable "schedule_expression" {
  description = "Schedule expression for Lambda function"
  type        = string
  default     = "rate(1 hour)"
}

variable "tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default = {
    Terraform   = "true"
    Environment = "dev"
    Project     = "s3-notifications"
  }
}

variable "random_string_length" {
  description = "Length of random string for unique naming"
  type        = number
  default     = 8
}