locals {
  base_outputs = data.terraform_remote_state.base.outputs.base_outputs

  metrics_config = {
    account_id = local.base_outputs.account_id
  }
}