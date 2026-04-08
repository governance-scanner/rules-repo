# Policy: DatabricksInstancePoolVMSKUValidator
# Resource type: databricks_instance_pool
# Checked attribute path: node_type_id
# Expected: FAIL because node_type_id is outside the configured allowlist.

terraform {
  required_providers {
    databricks = {
      source = "databricks/databricks"
    }
  }
}

provider "databricks" {}

data "databricks_spark_version" "fail_pool_vm_sku" {
  long_term_support = true
}

resource "databricks_instance_pool" "fail_pool_vm_sku" {
  instance_pool_name                    = "fail-pool-vm-sku"
  min_idle_instances                    = 0
  max_capacity                          = 20
  node_type_id                          = "Standard_E8ds_v4" # ❌ FAIL: not in the governance allowlist
  preloaded_spark_versions              = [data.databricks_spark_version.fail_pool_vm_sku.id]
  idle_instance_autotermination_minutes = 20
}
