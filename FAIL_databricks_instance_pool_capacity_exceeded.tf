# Policy: DatabricksPoolCapacityValidator
# Resource type: databricks_instance_pool
# Checked attribute path: max_capacity
# Expected: FAIL because max_capacity exceeds the threshold.

terraform {
  required_providers {
    databricks = {
      source = "databricks/databricks"
    }
  }
}

provider "databricks" {}

data "databricks_spark_version" "fail_pool_capacity_exceeded" {
  long_term_support = true
}

data "databricks_node_type" "fail_pool_capacity_exceeded" {
  local_disk = true
}

resource "databricks_instance_pool" "fail_pool_capacity_exceeded" {
  instance_pool_name                    = "fail-pool-capacity-exceeded"
  min_idle_instances                    = 0
  max_capacity                          = 150 # ❌ FAIL: exceeds the threshold of 100
  node_type_id                          = data.databricks_node_type.fail_pool_capacity_exceeded.id
  preloaded_spark_versions              = [data.databricks_spark_version.fail_pool_capacity_exceeded.id]
  idle_instance_autotermination_minutes = 20
}
