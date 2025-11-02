locals {
  db_name = replace("${var.aurora_config.name_prefix}-${var.aurora_config.db_name}", "-", "_")
}