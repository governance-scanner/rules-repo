# Policy: DatabricksSQLEndpointAutoStopValidator
# Resource type: databricks_sql_endpoint
# Checked attribute path: auto_stop_mins
# Expected: PASS because non-production auto_stop_mins is 15.

terraform {
  required_providers {
    databricks = {
      source = "databricks/databricks"
    }
  }
}

provider "databricks" {}

resource "databricks_sql_endpoint" "pass_sql_auto_stop" {
  name                    = "pass-sql-auto-stop"
  cluster_size            = "Small"
  max_num_clusters        = 1
  auto_stop_mins          = 15 # ✅ PASS: within the 30-minute threshold
  enable_serverless_compute = false
  warehouse_type          = "PRO"

  tags {
    custom_tags {
      key   = "environment"
      value = "dev"
    }
  }
}
