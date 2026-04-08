# Policy: DatabricksSQLEndpointClusterCountValidator
# Resource type: databricks_sql_endpoint
# Checked attribute path: max_num_clusters
# Expected: FAIL because non-production max_num_clusters exceeds 1.

terraform {
  required_providers {
    databricks = {
      source = "databricks/databricks"
    }
  }
}

provider "databricks" {}

resource "databricks_sql_endpoint" "fail_sql_cluster_count" {
  name                      = "fail-sql-cluster-count"
  cluster_size              = "Small"
  max_num_clusters          = 2 # ❌ FAIL: exceeds the threshold of 1
  auto_stop_mins            = 15
  enable_serverless_compute = false
  warehouse_type            = "PRO"

  tags {
    custom_tags {
      key   = "environment"
      value = "dev"
    }
  }
}
