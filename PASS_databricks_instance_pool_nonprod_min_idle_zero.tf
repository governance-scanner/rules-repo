# Policy: DatabricksInstancePoolMinIdleValidator
# Resource type: databricks_instance_pool
# Checked attribute path: min_idle_instances
# Expected: PASS because non-production min_idle_instances is 0.

terraform {
  required_providers {
    databricks = {
      source = "databricks/databricks"
    }
  }
}

provider "databricks" {}

data "databricks_spark_version" "pass_pool_min_idle" {
  long_term_support = true
}

resource "databricks_instance_pool" "pass_pool_min_idle" {
  instance_pool_name                    = "pass-pool-min-idle"
  min_idle_instances                    = 0 # ✅ PASS: no pre-warmed idle instances in non-production
  max_capacity                          = 20
  node_type_id                          = "Standard_DS3_v2"
  preloaded_spark_versions              = [data.databricks_spark_version.pass_pool_min_idle.id]
  idle_instance_autotermination_minutes = 20
  custom_tags = {
    environment = "dev"
  }
}
