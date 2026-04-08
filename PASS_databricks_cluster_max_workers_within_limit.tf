# Policy: DatabricksClusterMaxWorkersValidator
# Resource type: databricks_cluster
# Checked attribute paths: autoscale.max_workers and num_workers
# Expected: PASS because the fixed worker count is 3.

terraform {
  required_providers {
    databricks = {
      source = "databricks/databricks"
    }
  }
}

provider "databricks" {}

data "databricks_spark_version" "pass_cluster_max_workers" {
  long_term_support = true
}

data "databricks_node_type" "pass_cluster_max_workers" {
  local_disk = true
}

resource "databricks_cluster" "pass_cluster_max_workers" {
  cluster_name  = "pass-cluster-max-workers"
  spark_version = data.databricks_spark_version.pass_cluster_max_workers.id
  node_type_id  = data.databricks_node_type.pass_cluster_max_workers.id
  num_workers   = 3 # ✅ PASS: fixed worker count is within the limit of 5
  custom_tags = {
    environment = "dev"
  }
}
