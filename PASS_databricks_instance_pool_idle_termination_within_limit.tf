# Policy: DatabricksInstancePoolIdleTerminationValidator
# Resource type: databricks_instance_pool
# Checked attribute path: idle_instance_autotermination_minutes
# Expected: PASS because idle termination is set to 20 minutes.

terraform {
  required_providers {
    databricks = {
      source = "databricks/databricks"
    }
  }
}

provider "databricks" {}

data "databricks_spark_version" "pass_pool_idle_term" {
  long_term_support = true
}

data "databricks_node_type" "pass_pool_idle_term" {
  local_disk = true
}

resource "databricks_instance_pool" "pass_pool_idle_term" {
  instance_pool_name                      = "pass-pool-idle-term"
  min_idle_instances                      = 0
  max_capacity                            = 30
  node_type_id                            = data.databricks_node_type.pass_pool_idle_term.id
  preloaded_spark_versions                = [data.databricks_spark_version.pass_pool_idle_term.id]
  idle_instance_autotermination_minutes   = 20 # ✅ PASS: within the 30-minute threshold
}
