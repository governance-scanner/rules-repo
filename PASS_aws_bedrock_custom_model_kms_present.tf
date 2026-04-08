# Policy: AWSBedrockKMSEncryptionValidation
# Resource type: aws_bedrock_custom_model
# Checked attribute path: custom_model_kms_key_id
# Expected: PASS because custom_model_kms_key_id is set.

provider "aws" {
  region = "us-east-1"
}

data "aws_bedrock_foundation_model" "pass_bedrock_kms" {
  model_id = "amazon.titan-text-express-v1"
}

resource "aws_s3_bucket" "training_pass_bedrock_kms" {
  bucket = "training-pass-bedrock-kms-example"
}

resource "aws_s3_bucket" "output_pass_bedrock_kms" {
  bucket = "output-pass-bedrock-kms-example"
}

resource "aws_kms_key" "pass_bedrock_kms" {
  description = "KMS key for Bedrock custom model"
}

resource "aws_iam_role" "pass_bedrock_kms" {
  name = "bedrock-custom-model-pass-kms-role"
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

resource "aws_bedrock_custom_model" "pass_bedrock_kms" {
  custom_model_name       = "pass-bedrock-kms-model"
  job_name                = "pass-bedrock-kms-job"
  base_model_identifier   = data.aws_bedrock_foundation_model.pass_bedrock_kms.model_arn
  role_arn                = aws_iam_role.pass_bedrock_kms.arn
  custom_model_kms_key_id = aws_kms_key.pass_bedrock_kms.arn # ✅ PASS: customer-managed KMS key is set
  hyperparameters = {
    epochCount              = "1"
    batchSize               = "1"
    learningRate            = "0.005"
    learningRateWarmupSteps = "0"
  }
  training_data_config {
    s3_uri = "s3://${aws_s3_bucket.training_pass_bedrock_kms.id}/data/train.jsonl"
  }
  output_data_config {
    s3_uri = "s3://${aws_s3_bucket.output_pass_bedrock_kms.id}/data/"
  }
}
