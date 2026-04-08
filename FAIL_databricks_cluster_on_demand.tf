# Policy: DatabricksClusterSpotInstanceValidator
# Resource type: databricks_cluster
# Checked attribute path: aws_attributes.availability
# Expected: FAIL because the non-production cluster uses on-demand instances.

terraform {
  required_providers {
    databricks = {
      source = "databricks/databricks"
    }
  }
}

provider "databricks" {}

data "databricks_spark_version" "fail_cluster_spot" {
  long_term_support = true
}

data "databricks_node_type" "fail_cluster_spot" {
  local_disk = true
}

resource "databricks_cluster" "fail_cluster_spot" {
  cluster_name  = "fail-cluster-ondemand"
  spark_version = data.databricks_spark_version.fail_cluster_spot.id
  node_type_id  = data.databricks_node_type.fail_cluster_spot.id
  num_workers   = 1
  custom_tags = {
    environment = "dev"
  }

  aws_attributes {
    availability = "ON_DEMAND" # ❌ FAIL: on-demand is denied in non-production
  }
}
