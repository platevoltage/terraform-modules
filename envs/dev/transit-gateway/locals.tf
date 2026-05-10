locals {
  base_config = data.terraform_remote_state.base_config.outputs.base_config
  vpc_outputs = data.terraform_remote_state.vpc.outputs.vpc_outputs

  transit_gateway_config = {
    account_id         = local.base_config.account_id
    env                = local.base_config.env
    project            = local.base_config.project
    aws_region         = local.base_config.aws_region
    name_prefix        = local.base_config.name_prefix
    amazon_side_asn    = 64512
    vpc_id             = local.vpc_outputs.vpc_id
    private_subnet_ids = local.vpc_outputs.private_subnet_ids
    flow_logs_enabled  = true
    common_tags        = local.base_config.common_tags
  }
}
