# Policy: AWSBedrockPrivateVPCValidation
# Resource type: aws_bedrock_custom_model
# Checked attribute path: vpc_config.subnet_ids
# Expected: FAIL because vpc_config is omitted and subnet_ids are absent.

provider "aws" {
  region = "us-east-1"
}

data "aws_bedrock_foundation_model" "fail_bedrock_vpc" {
  model_id = "amazon.titan-text-express-v1"
}

resource "aws_s3_bucket" "training_fail_bedrock_vpc" {
  bucket = "training-fail-bedrock-vpc-example"
}

resource "aws_s3_bucket" "output_fail_bedrock_vpc" {
  bucket = "output-fail-bedrock-vpc-example"
}

resource "aws_iam_role" "fail_bedrock_vpc" {
  name = "bedrock-custom-model-fail-vpc-role"
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

resource "aws_bedrock_custom_model" "fail_bedrock_vpc" {
  custom_model_name    = "fail-bedrock-vpc-model"
  job_name             = "fail-bedrock-vpc-job"
  base_model_identifier = data.aws_bedrock_foundation_model.fail_bedrock_vpc.model_arn
  role_arn             = aws_iam_role.fail_bedrock_vpc.arn
  hyperparameters = {
    epochCount              = "1"
    batchSize               = "1"
    learningRate            = "0.005"
    learningRateWarmupSteps = "0"
  }
  training_data_config {
    s3_uri = "s3://${aws_s3_bucket.training_fail_bedrock_vpc.id}/data/train.jsonl"
  }
  output_data_config {
    s3_uri = "s3://${aws_s3_bucket.output_fail_bedrock_vpc.id}/data/"
  }
  # ❌ FAIL: vpc_config omitted, so subnet_ids are missing
}
