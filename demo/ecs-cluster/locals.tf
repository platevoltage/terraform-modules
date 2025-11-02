locals {
  base_config = data.terraform_remote_state.base.outputs.base_config

  ecs_cluster_config = merge(
    local.base_config,
    {
      ssh_key_name           = "${local.base_config.name_prefix}-bastion-key"
      seed_bucket            = "${local.base_config.name_prefix}-seed-bucket-404008372783"
      tags                   = local.base_config.common_tags
      ecs_execution_role_arn = ""
      cluster_name_override  = ""
    }
  )
}
