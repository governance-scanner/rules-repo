# Policy: DatabricksSQLEndpointWarehouseSizeValidator
# Resource type: databricks_sql_endpoint
# Checked attribute path: cluster_size
# Expected: FAIL because non-production cluster_size is Large.

terraform {
  required_providers {
    databricks = {
      source = "databricks/databricks"
    }
  }
}

provider "databricks" {}

resource "databricks_sql_endpoint" "fail_sql_warehouse_size" {
  name                      = "fail-sql-warehouse-size"
  cluster_size              = "Large" # ❌ FAIL: larger than the allowed non-production sizes
  max_num_clusters          = 1
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
