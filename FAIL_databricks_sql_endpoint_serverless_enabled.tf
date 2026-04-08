# Policy: DatabricksSQLEndpointServerlessValidator
# Resource type: databricks_sql_endpoint
# Checked attribute path: enable_serverless_compute
# Expected: FAIL because non-production serverless compute is enabled.

terraform {
  required_providers {
    databricks = {
      source = "databricks/databricks"
    }
  }
}

provider "databricks" {}

resource "databricks_sql_endpoint" "fail_sql_serverless" {
  name                      = "fail-sql-serverless"
  cluster_size              = "Small"
  max_num_clusters          = 1
  auto_stop_mins            = 15
  enable_serverless_compute = true # ❌ FAIL: serverless compute is enabled
  warehouse_type            = "PRO"

  tags {
    custom_tags {
      key   = "environment"
      value = "dev"
    }
  }
}
