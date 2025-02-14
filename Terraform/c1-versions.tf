# Terraform Block
terraform {
  required_version = ">= 1.9" # which means any version equal & above 0.14 like 0.15, 0.16 etc and < 1.xx
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
  backend "s3" {
    encrypt = true    
    bucket = "terraform-state-storage-santosh"
    dynamodb_table = "terraform-dynamodb"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}

# Provider Block
provider "aws" {
  region  = var.aws_region
  profile = "default"
}