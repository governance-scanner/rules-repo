# Policy: DatabricksSQLEndpointWarehouseSizeValidator
# Resource type: databricks_sql_endpoint
# Checked attribute path: cluster_size
# Expected: PASS because non-production cluster_size is Small.

terraform {
  required_providers {
    databricks = {
      source = "databricks/databricks"
    }
  }
}

provider "databricks" {}

resource "databricks_sql_endpoint" "pass_sql_warehouse_size" {
  name                      = "pass-sql-warehouse-size"
  cluster_size              = "Small" # ✅ PASS: allowed non-production warehouse size
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
