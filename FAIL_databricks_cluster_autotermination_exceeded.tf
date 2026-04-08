# Policy: DatabricksClusterAutoTerminationValidator
# Resource type: databricks_cluster
# Checked attribute path: autotermination_minutes
# Expected: FAIL because non-production autotermination_minutes exceeds 60.

terraform {
  required_providers {
    databricks = {
      source = "databricks/databricks"
    }
  }
}

provider "databricks" {}

data "databricks_spark_version" "fail_cluster_auto_term" {
  long_term_support = true
}

data "databricks_node_type" "fail_cluster_auto_term" {
  local_disk = true
}

resource "databricks_cluster" "fail_cluster_auto_term" {
  cluster_name            = "fail-cluster-auto-term"
  spark_version           = data.databricks_spark_version.fail_cluster_auto_term.id
  node_type_id            = data.databricks_node_type.fail_cluster_auto_term.id
  autotermination_minutes = 120 # ❌ FAIL: exceeds the 60-minute threshold
  num_workers             = 1
  custom_tags = {
    environment = "dev"
  }
}
