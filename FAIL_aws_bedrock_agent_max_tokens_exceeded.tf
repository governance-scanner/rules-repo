# Policy: AWSBedrockAgentValidation
# Resource type: aws_bedrockagent_agent
# Checked attribute path: prompt_override_configuration.prompt_configurations.inference_configuration.max_length
# Expected by latest docs: FAIL because max_length exceeds 4096.
# Scanner risk: current allowlist may fail earlier on foundation_model before this max_length branch is reached.

provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_role" "fail_bedrock_agent_tokens" {
  name = "bedrock-agent-fail-tokens-role"
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

resource "aws_bedrockagent_agent" "fail_bedrock_agent_tokens" {
  agent_name              = "fail-bedrock-agent-tokens"
  agent_resource_role_arn = aws_iam_role.fail_bedrock_agent_tokens.arn
  foundation_model        = "meta.llama3-8b-instruct-v1:0" # ✅ Doc-aligned model ID, but scanner allowlist may reject it before token evaluation
  instruction             = "This Bedrock agent intentionally exceeds the prompt token threshold to exercise the second failure branch once the allowlist is updated."

  prompt_override_configuration {
    prompt_configurations {
      base_prompt_template = "You are an agent that always responds with structured analysis."
      parser_mode          = "DEFAULT"
      prompt_creation_mode = "OVERRIDDEN"
      prompt_state         = "ENABLED"
      prompt_type          = "ORCHESTRATION"

      inference_configuration {
        max_length     = 5000 # ❌ FAIL: above definitions.AWSBedrockAgentDefinitions.TOKEN_THRESHOLD
        stop_sequences = ["Observation:"]
        temperature    = 0.1
        top_k          = 50
        top_p          = 1
      }
    }
  }
}
