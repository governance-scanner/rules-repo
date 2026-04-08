# Policy: DatabricksClusterMaxWorkersValidator
# Resource type: databricks_cluster
# Checked attribute path: num_workers
# Expected: FAIL because the fixed worker count exceeds 5.

terraform {
  required_providers {
    databricks = {
      source = "databricks/databricks"
    }
  }
}

provider "databricks" {}

data "databricks_spark_version" "fail_cluster_max_workers_fixed" {
  long_term_support = true
}

data "databricks_node_type" "fail_cluster_max_workers_fixed" {
  local_disk = true
}

resource "databricks_cluster" "fail_cluster_max_workers_fixed" {
  cluster_name  = "fail-cluster-max-workers-fixed"
  spark_version = data.databricks_spark_version.fail_cluster_max_workers_fixed.id
  node_type_id  = data.databricks_node_type.fail_cluster_max_workers_fixed.id
  num_workers   = 6 # ❌ FAIL: fixed worker count exceeds the limit of 5
  custom_tags = {
    environment = "dev"
  }
}
