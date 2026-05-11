locals {
  base_config = data.terraform_remote_state.base_config.outputs.base_config

  vpc_config = {
    account_id        = local.base_config.account_id
    env               = local.base_config.env
    project           = local.base_config.project
    aws_region        = local.base_config.aws_region
    name_prefix       = local.base_config.name_prefix
    vpc_cidr          = "10.1.20.0/24"
    az_count          = 1
    subnet_newbits    = 2
    flow_logs_enabled = true
    common_tags       = local.base_config.common_tags
  }
}
