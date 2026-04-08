# Policy: AWSBedrockPrivateVPCValidation
# Resource type: aws_bedrock_custom_model
# Checked attribute path: vpc_config.subnet_ids
# Expected: PASS because subnet_ids are present under vpc_config.

provider "aws" {
  region = "us-east-1"
}

data "aws_bedrock_foundation_model" "pass_bedrock_vpc" {
  model_id = "amazon.titan-text-express-v1"
}

resource "aws_s3_bucket" "training_pass_bedrock_vpc" {
  bucket = "training-pass-bedrock-vpc-example"
}

resource "aws_s3_bucket" "output_pass_bedrock_vpc" {
  bucket = "output-pass-bedrock-vpc-example"
}

resource "aws_vpc" "pass_bedrock_vpc" {
  cidr_block = "10.60.0.0/16"
}

resource "aws_subnet" "pass_bedrock_vpc" {
  vpc_id            = aws_vpc.pass_bedrock_vpc.id
  cidr_block        = "10.60.1.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_security_group" "pass_bedrock_vpc" {
  name        = "sg-pass-bedrock-vpc"
  description = "Bedrock customization SG"
  vpc_id      = aws_vpc.pass_bedrock_vpc.id
}

resource "aws_iam_role" "pass_bedrock_vpc" {
  name = "bedrock-custom-model-pass-vpc-role"
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

resource "aws_bedrock_custom_model" "pass_bedrock_vpc" {
  custom_model_name    = "pass-bedrock-vpc-model"
  job_name             = "pass-bedrock-vpc-job"
  base_model_identifier = data.aws_bedrock_foundation_model.pass_bedrock_vpc.model_arn
  role_arn             = aws_iam_role.pass_bedrock_vpc.arn
  hyperparameters = {
    epochCount              = "1"
    batchSize               = "1"
    learningRate            = "0.005"
    learningRateWarmupSteps = "0"
  }
  training_data_config {
    s3_uri = "s3://${aws_s3_bucket.training_pass_bedrock_vpc.id}/data/train.jsonl"
  }
  output_data_config {
    s3_uri = "s3://${aws_s3_bucket.output_pass_bedrock_vpc.id}/data/"
  }
  vpc_config {
    subnet_ids         = [aws_subnet.pass_bedrock_vpc.id] # ✅ PASS: subnet_ids are present
    security_group_ids = [aws_security_group.pass_bedrock_vpc.id]
  }
}
