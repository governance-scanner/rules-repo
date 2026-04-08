# Policy: AWSBedrockAgentValidation
# Resource type: aws_bedrockagent_agent
# Checked attribute paths: foundation_model and prompt_override_configuration.prompt_configurations.inference_configuration.max_length
# Expected by latest docs: PASS because foundation_model uses a current documented Bedrock model ID and no token override exceeds 4096.
# Scanner risk: current governance input_details still use stale model IDs, so this file may fail until policy allowlist is updated.

provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_role" "pass_bedrock_agent" {
  name = "bedrock-agent-pass-role"
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

resource "aws_bedrockagent_agent" "pass_bedrock_agent" {
  agent_name              = "pass-bedrock-agent"
  agent_resource_role_arn = aws_iam_role.pass_bedrock_agent.arn
  foundation_model        = "meta.llama3-8b-instruct-v1:0" # ✅ Doc-aligned: current Bedrock-supported model ID
  instruction             = "This Bedrock agent uses a current documented model identifier and stays within token guardrails for doc-aligned fixture coverage."
}
