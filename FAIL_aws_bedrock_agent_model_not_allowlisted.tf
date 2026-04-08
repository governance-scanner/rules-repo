# Policy: AWSBedrockAgentValidation
# Resource type: aws_bedrockagent_agent
# Checked attribute path: foundation_model
# Expected by latest docs: this is a valid Bedrock model ID, but it is outside the current governance allowlist.
# Scanner expectation: FAIL until the governance allowlist is modernized.

provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_role" "fail_bedrock_agent_model" {
  name = "bedrock-agent-fail-model-role"
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

resource "aws_bedrockagent_agent" "fail_bedrock_agent_model" {
  agent_name              = "fail-bedrock-agent-model"
  agent_resource_role_arn = aws_iam_role.fail_bedrock_agent_model.arn
  foundation_model        = "amazon.titan-text-premier-v1:0" # ❌ FAIL for current scanner allowlist, while remaining doc-aligned
  instruction             = "This Bedrock agent uses a current documented model identifier that is not present in the current governance allowlist."
}
