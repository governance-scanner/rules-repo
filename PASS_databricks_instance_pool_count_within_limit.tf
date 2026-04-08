# Policy: DatabricksInstancePoolCountValidator
# Resource type: databricks_instance_pool
# Checked attribute path: workspace pool count
# Expected: PASS because this file defines exactly 3 pools.

terraform {
  required_providers {
    databricks = {
      source = "databricks/databricks"
    }
  }
}

provider "databricks" {}

data "databricks_spark_version" "pass_pool_count" {
  long_term_support = true
}

data "databricks_node_type" "pass_pool_count" {
  local_disk = true
}

resource "databricks_instance_pool" "pass_pool_count_one" {
  instance_pool_name                    = "pass-pool-count-one"
  min_idle_instances                    = 0
  max_capacity                          = 10
  node_type_id                          = data.databricks_node_type.pass_pool_count.id
  preloaded_spark_versions              = [data.databricks_spark_version.pass_pool_count.id]
  idle_instance_autotermination_minutes = 20
}

resource "databricks_instance_pool" "pass_pool_count_two" {
  instance_pool_name                    = "pass-pool-count-two"
  min_idle_instances                    = 0
  max_capacity                          = 10
  node_type_id                          = data.databricks_node_type.pass_pool_count.id
  preloaded_spark_versions              = [data.databricks_spark_version.pass_pool_count.id]
  idle_instance_autotermination_minutes = 20
}

resource "databricks_instance_pool" "pass_pool_count_three" {
  instance_pool_name                    = "pass-pool-count-three"
  min_idle_instances                    = 0
  max_capacity                          = 10
  node_type_id                          = data.databricks_node_type.pass_pool_count.id
  preloaded_spark_versions              = [data.databricks_spark_version.pass_pool_count.id]
  idle_instance_autotermination_minutes = 20
}
