# Policy: DatabricksPoolCapacityValidator
# Resource type: databricks_instance_pool
# Checked attribute path: max_capacity
# Expected: FAIL because max_capacity is omitted.

terraform {
  required_providers {
    databricks = {
      source = "databricks/databricks"
    }
  }
}

provider "databricks" {}

data "databricks_spark_version" "fail_pool_capacity_missing" {
  long_term_support = true
}

data "databricks_node_type" "fail_pool_capacity_missing" {
  local_disk = true
}

resource "databricks_instance_pool" "fail_pool_capacity_missing" {
  instance_pool_name                    = "fail-pool-capacity-missing"
  min_idle_instances                    = 0
  node_type_id                          = data.databricks_node_type.fail_pool_capacity_missing.id
  preloaded_spark_versions              = [data.databricks_spark_version.fail_pool_capacity_missing.id]
  idle_instance_autotermination_minutes = 20
  # ❌ FAIL: max_capacity is intentionally omitted
}
