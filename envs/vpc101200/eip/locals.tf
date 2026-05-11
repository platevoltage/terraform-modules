locals {
  base_config = data.terraform_remote_state.base_config.outputs.base_config

  eip_config = {
    name_prefix = local.base_config.name_prefix
    common_tags = local.base_config.common_tags
  }
}
