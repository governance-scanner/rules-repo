# Policy: DatabricksSQLEndpointServerlessValidator
# Resource type: databricks_sql_endpoint
# Checked attribute path: enable_serverless_compute
# Expected: PASS because non-production serverless compute is disabled.

terraform {
  required_providers {
    databricks = {
      source = "databricks/databricks"
    }
  }
}

provider "databricks" {}

resource "databricks_sql_endpoint" "pass_sql_serverless" {
  name                      = "pass-sql-serverless"
  cluster_size              = "Small"
  max_num_clusters          = 1
  auto_stop_mins            = 15
  enable_serverless_compute = false # ✅ PASS: serverless compute is disabled
  warehouse_type            = "PRO"

  tags {
    custom_tags {
      key   = "environment"
      value = "dev"
    }
  }
}
