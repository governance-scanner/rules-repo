# Policy: DatabricksClusterAutoTerminationValidator
# Resource type: databricks_cluster
# Checked attribute path: autotermination_minutes
# Expected: PASS because non-production autotermination_minutes is 30.

terraform {
  required_providers {
    databricks = {
      source = "databricks/databricks"
    }
  }
}

provider "databricks" {}

data "databricks_spark_version" "pass_cluster_auto_term" {
  long_term_support = true
}

data "databricks_node_type" "pass_cluster_auto_term" {
  local_disk = true
}

resource "databricks_cluster" "pass_cluster_auto_term" {
  cluster_name            = "pass-cluster-auto-term"
  spark_version           = data.databricks_spark_version.pass_cluster_auto_term.id
  node_type_id            = data.databricks_node_type.pass_cluster_auto_term.id
  autotermination_minutes = 30 # ✅ PASS: within the 60-minute threshold
  num_workers             = 1
  custom_tags = {
    environment = "dev"
  }
}
