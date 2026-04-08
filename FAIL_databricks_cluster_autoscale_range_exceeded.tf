# Policy: DatabricksClusterAutoscaleRangeValidator
# Resource type: databricks_cluster
# Checked attribute path: autoscale.max_workers - autoscale.min_workers
# Expected: FAIL because the non-production autoscale range is greater than 5.

terraform {
  required_providers {
    databricks = {
      source = "databricks/databricks"
    }
  }
}

provider "databricks" {}

data "databricks_spark_version" "fail_cluster_autoscale_range" {
  long_term_support = true
}

data "databricks_node_type" "fail_cluster_autoscale_range" {
  local_disk = true
}

resource "databricks_cluster" "fail_cluster_autoscale_range" {
  cluster_name  = "fail-cluster-autoscale-range"
  spark_version = data.databricks_spark_version.fail_cluster_autoscale_range.id
  node_type_id  = data.databricks_node_type.fail_cluster_autoscale_range.id
  custom_tags = {
    environment = "dev"
  }

  autoscale {
    min_workers = 1
    max_workers = 8 # ❌ FAIL: range is 7, which exceeds the limit of 5
  }
}
