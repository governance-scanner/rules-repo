# Policy: DatabricksClusterPhotonValidator
# Resource type: databricks_cluster
# Checked attribute paths: spark_version and runtime_engine
# Expected: PASS because runtime_engine is STANDARD and the runtime string is non-Photon.

terraform {
  required_providers {
    databricks = {
      source = "databricks/databricks"
    }
  }
}

provider "databricks" {}

data "databricks_spark_version" "pass_cluster_photon" {
  long_term_support = true
}

data "databricks_node_type" "pass_cluster_photon" {
  local_disk = true
}

resource "databricks_cluster" "pass_cluster_photon" {
  cluster_name    = "pass-cluster-standard-runtime"
  spark_version   = data.databricks_spark_version.pass_cluster_photon.id
  node_type_id    = data.databricks_node_type.pass_cluster_photon.id
  num_workers     = 1
  runtime_engine  = "STANDARD" # ✅ PASS: Photon is not enabled
  custom_tags = {
    environment = "dev"
  }
}
