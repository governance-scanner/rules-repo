# Policy: DatabricksClusterSpotInstanceValidator
# Resource type: databricks_cluster
# Checked attribute path: aws_attributes.availability
# Expected: PASS because the non-production cluster uses spot with fallback.

terraform {
  required_providers {
    databricks = {
      source = "databricks/databricks"
    }
  }
}

provider "databricks" {}

data "databricks_spark_version" "pass_cluster_spot" {
  long_term_support = true
}

data "databricks_node_type" "pass_cluster_spot" {
  local_disk = true
}

resource "databricks_cluster" "pass_cluster_spot" {
  cluster_name  = "pass-cluster-spot"
  spark_version = data.databricks_spark_version.pass_cluster_spot.id
  node_type_id  = data.databricks_node_type.pass_cluster_spot.id
  num_workers   = 1
  custom_tags = {
    environment = "dev"
  }

  aws_attributes {
    availability = "SPOT_WITH_FALLBACK" # ✅ PASS: not on-demand
  }
}
