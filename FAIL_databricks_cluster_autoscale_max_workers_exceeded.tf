# Policy: DatabricksClusterMaxWorkersValidator
# Resource type: databricks_cluster
# Checked attribute path: autoscale.max_workers
# Expected: FAIL because the autoscale max_workers value exceeds 5.

terraform {
  required_providers {
    databricks = {
      source = "databricks/databricks"
    }
  }
}

provider "databricks" {}

data "databricks_spark_version" "fail_cluster_max_workers_auto" {
  long_term_support = true
}

data "databricks_node_type" "fail_cluster_max_workers_auto" {
  local_disk = true
}

resource "databricks_cluster" "fail_cluster_max_workers_auto" {
  cluster_name  = "fail-cluster-max-workers-auto"
  spark_version = data.databricks_spark_version.fail_cluster_max_workers_auto.id
  node_type_id  = data.databricks_node_type.fail_cluster_max_workers_auto.id
  custom_tags = {
    environment = "dev"
  }

  autoscale {
    min_workers = 1
    max_workers = 6 # ❌ FAIL: autoscale max_workers exceeds the limit of 5
  }
}
