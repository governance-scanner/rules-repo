# Policy: DatabricksClusterAutoscaleRangeValidator
# Resource type: databricks_cluster
# Checked attribute path: autoscale.max_workers - autoscale.min_workers
# Expected: PASS because the non-production autoscale range is 3.

terraform {
  required_providers {
    databricks = {
      source = "databricks/databricks"
    }
  }
}

provider "databricks" {}

data "databricks_spark_version" "pass_cluster_autoscale_range" {
  long_term_support = true
}

data "databricks_node_type" "pass_cluster_autoscale_range" {
  local_disk = true
}

resource "databricks_cluster" "pass_cluster_autoscale_range" {
  cluster_name  = "pass-cluster-autoscale-range"
  spark_version = data.databricks_spark_version.pass_cluster_autoscale_range.id
  node_type_id  = data.databricks_node_type.pass_cluster_autoscale_range.id
  custom_tags = {
    environment = "dev"
  }

  autoscale {
    min_workers = 1
    max_workers = 4 # ✅ PASS: range is 3, within the limit of 5
  }
}
