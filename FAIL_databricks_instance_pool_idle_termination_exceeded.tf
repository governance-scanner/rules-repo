# Policy: DatabricksInstancePoolIdleTerminationValidator
# Resource type: databricks_instance_pool
# Checked attribute path: idle_instance_autotermination_minutes
# Expected: FAIL because idle termination exceeds 30 minutes.

terraform {
  required_providers {
    databricks = {
      source = "databricks/databricks"
    }
  }
}

provider "databricks" {}

data "databricks_spark_version" "fail_pool_idle_term" {
  long_term_support = true
}

data "databricks_node_type" "fail_pool_idle_term" {
  local_disk = true
}

resource "databricks_instance_pool" "fail_pool_idle_term" {
  instance_pool_name                      = "fail-pool-idle-term"
  min_idle_instances                      = 0
  max_capacity                            = 30
  node_type_id                            = data.databricks_node_type.fail_pool_idle_term.id
  preloaded_spark_versions                = [data.databricks_spark_version.fail_pool_idle_term.id]
  idle_instance_autotermination_minutes   = 60 # ❌ FAIL: exceeds the 30-minute threshold
}
