# Policy: DatabricksClusterPhotonValidator
# Resource type: databricks_cluster
# Checked attribute path: runtime_engine
# Expected: FAIL because Photon is explicitly enabled through runtime_engine.

terraform {
  required_providers {
    databricks = {
      source = "databricks/databricks"
    }
  }
}

provider "databricks" {}

data "databricks_spark_version" "fail_cluster_photon" {
  long_term_support = true
}

data "databricks_node_type" "fail_cluster_photon" {
  local_disk = true
}

resource "databricks_cluster" "fail_cluster_photon" {
  cluster_name   = "fail-cluster-runtime-photon"
  spark_version  = data.databricks_spark_version.fail_cluster_photon.id
  node_type_id   = data.databricks_node_type.fail_cluster_photon.id
  num_workers    = 1
  runtime_engine = "PHOTON" # ❌ FAIL: Photon is enabled
  custom_tags = {
    environment = "dev"
  }
}
