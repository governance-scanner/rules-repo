# Policy: DatabricksSQLEndpointAutoStopValidator
# Resource type: databricks_sql_endpoint
# Checked attribute path: auto_stop_mins
# Expected: FAIL because non-production auto_stop_mins exceeds 30.

terraform {
  required_providers {
    databricks = {
      source = "databricks/databricks"
    }
  }
}

provider "databricks" {}

resource "databricks_sql_endpoint" "fail_sql_auto_stop" {
  name                      = "fail-sql-auto-stop"
  cluster_size              = "Small"
  max_num_clusters          = 1
  auto_stop_mins            = 45 # ❌ FAIL: exceeds the 30-minute threshold
  enable_serverless_compute = false
  warehouse_type            = "PRO"

  tags {
    custom_tags {
      key   = "environment"
      value = "dev"
    }
  }
}
