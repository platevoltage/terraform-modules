locals {
  base_config = data.terraform_remote_state.base_config.outputs.base_config
  vpc_outputs = data.terraform_remote_state.vpc.outputs.vpc_outputs

  igw_config = {
    name_prefix = local.base_config.name_prefix
    common_tags = local.base_config.common_tags
    vpc_id      = local.vpc_outputs.vpc_id
    subnet_ids  = local.vpc_outputs.public_subnet_ids
  }
}
