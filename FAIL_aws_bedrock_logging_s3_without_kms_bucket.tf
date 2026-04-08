# Policy: AWSBedrockLoggingValidation
# Resource type: aws_bedrock_model_invocation_logging_configuration
# Checked attribute path in current scanner: logging_config.s3_config.kms_key_id
# Expected by latest docs: FAIL because the S3 logging destination is not encrypted with a KMS key.
# This file is doc-aligned but scanner-risky because bucket encryption is configured outside the logging resource.

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}
data "aws_region" "current" {}

resource "aws_s3_bucket" "fail_bedrock_logging" {
  bucket        = "fail-bedrock-logging-batch4-001"
  force_destroy = true
}

resource "aws_s3_bucket_policy" "fail_bedrock_logging" {
  bucket = aws_s3_bucket.fail_bedrock_logging.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AmazonBedrockLogsWrite"
        Effect = "Allow"
        Principal = {
          Service = "bedrock.amazonaws.com"
        }
        Action   = ["s3:PutObject"]
        Resource = ["${aws_s3_bucket.fail_bedrock_logging.arn}/invocation-logs/AWSLogs/${data.aws_caller_identity.current.account_id}/BedrockModelInvocationLogs/*"]
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = data.aws_caller_identity.current.account_id
          }
          ArnLike = {
            "aws:SourceArn" = "arn:${data.aws_partition.current.partition}:bedrock:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*"
          }
        }
      }
    ]
  })
}

resource "aws_bedrock_model_invocation_logging_configuration" "fail_bedrock_logging" {
  logging_config {
    text_data_delivery_enabled = true

    s3_config {
      bucket_name = aws_s3_bucket.fail_bedrock_logging.id
      key_prefix  = "invocation-logs" # ❌ FAIL: bucket is not configured with KMS encryption
    }
  }
}
