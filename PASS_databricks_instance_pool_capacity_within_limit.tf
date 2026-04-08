# Policy: DatabricksPoolCapacityValidator
# Resource type: databricks_instance_pool
# Checked attribute path: max_capacity
# Expected: PASS because max_capacity is within the threshold.

terraform {
  required_providers {
    databricks = {
      source = "databricks/databricks"
    }
  }
}

provider "databricks" {}

data "databricks_spark_version" "pass_pool_capacity" {
  long_term_support = true
}

data "databricks_node_type" "pass_pool_capacity" {
  local_disk = true
}

resource "databricks_instance_pool" "pass_pool_capacity" {
  instance_pool_name                    = "pass-pool-capacity"
  min_idle_instances                    = 0
  max_capacity                          = 50 # ✅ PASS: within the threshold of 100
  node_type_id                          = data.databricks_node_type.pass_pool_capacity.id
  preloaded_spark_versions              = [data.databricks_spark_version.pass_pool_capacity.id]
  idle_instance_autotermination_minutes = 20
}
