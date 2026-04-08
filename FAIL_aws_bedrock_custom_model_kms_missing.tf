# Policy: AWSBedrockKMSEncryptionValidation
# Resource type: aws_bedrock_custom_model
# Checked attribute path: custom_model_kms_key_id
# Expected: FAIL because custom_model_kms_key_id is omitted.

provider "aws" {
  region = "us-east-1"
}

data "aws_bedrock_foundation_model" "fail_bedrock_kms" {
  model_id = "amazon.titan-text-express-v1"
}

resource "aws_s3_bucket" "training_fail_bedrock_kms" {
  bucket = "training-fail-bedrock-kms-example"
}

resource "aws_s3_bucket" "output_fail_bedrock_kms" {
  bucket = "output-fail-bedrock-kms-example"
}

resource "aws_iam_role" "fail_bedrock_kms" {
  name = "bedrock-custom-model-fail-kms-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "bedrock.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_bedrock_custom_model" "fail_bedrock_kms" {
  custom_model_name     = "fail-bedrock-kms-model"
  job_name              = "fail-bedrock-kms-job"
  base_model_identifier = data.aws_bedrock_foundation_model.fail_bedrock_kms.model_arn
  role_arn              = aws_iam_role.fail_bedrock_kms.arn
  hyperparameters = {
    epochCount              = "1"
    batchSize               = "1"
    learningRate            = "0.005"
    learningRateWarmupSteps = "0"
  }
  training_data_config {
    s3_uri = "s3://${aws_s3_bucket.training_fail_bedrock_kms.id}/data/train.jsonl"
  }
  output_data_config {
    s3_uri = "s3://${aws_s3_bucket.output_fail_bedrock_kms.id}/data/"
  }
  # ❌ FAIL: custom_model_kms_key_id omitted
}
