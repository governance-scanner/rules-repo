# Policy: DatabricksInstancePoolVMSKUValidator
# Resource type: databricks_instance_pool
# Checked attribute path: node_type_id
# Expected: PASS because node_type_id is in the configured allowlist.

terraform {
  required_providers {
    databricks = {
      source = "databricks/databricks"
    }
  }
}

provider "databricks" {}

data "databricks_spark_version" "pass_pool_vm_sku" {
  long_term_support = true
}

resource "databricks_instance_pool" "pass_pool_vm_sku" {
  instance_pool_name                    = "pass-pool-vm-sku"
  min_idle_instances                    = 0
  max_capacity                          = 20
  node_type_id                          = "Standard_DS3_v2" # ✅ PASS: in the governance allowlist
  preloaded_spark_versions              = [data.databricks_spark_version.pass_pool_vm_sku.id]
  idle_instance_autotermination_minutes = 20
}
