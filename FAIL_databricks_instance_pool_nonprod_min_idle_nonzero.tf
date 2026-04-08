# Policy: DatabricksInstancePoolMinIdleValidator
# Resource type: databricks_instance_pool
# Checked attribute path: min_idle_instances
# Expected: FAIL because non-production min_idle_instances is greater than 0.

terraform {
  required_providers {
    databricks = {
      source = "databricks/databricks"
    }
  }
}

provider "databricks" {}

data "databricks_spark_version" "fail_pool_min_idle" {
  long_term_support = true
}

resource "databricks_instance_pool" "fail_pool_min_idle" {
  instance_pool_name                    = "fail-pool-min-idle"
  min_idle_instances                    = 2 # ❌ FAIL: pre-warmed idle instances are not allowed in non-production
  max_capacity                          = 20
  node_type_id                          = "Standard_DS3_v2"
  preloaded_spark_versions              = [data.databricks_spark_version.fail_pool_min_idle.id]
  idle_instance_autotermination_minutes = 20
  custom_tags = {
    environment = "dev"
  }
}
