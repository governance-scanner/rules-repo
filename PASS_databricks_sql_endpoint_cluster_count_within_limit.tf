# Policy: DatabricksSQLEndpointClusterCountValidator
# Resource type: databricks_sql_endpoint
# Checked attribute path: max_num_clusters
# Expected: PASS because non-production max_num_clusters is 1.

terraform {
  required_providers {
    databricks = {
      source = "databricks/databricks"
    }
  }
}

provider "databricks" {}

resource "databricks_sql_endpoint" "pass_sql_cluster_count" {
  name                      = "pass-sql-cluster-count"
  cluster_size              = "Small"
  max_num_clusters          = 1 # ✅ PASS: within the threshold of 1
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
