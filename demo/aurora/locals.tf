locals {
  base_outputs = data.terraform_remote_state.base.outputs.base_outputs

  aurora_config = {
    db_name            = var.db_name
    admin_email        = var.admin_email
    account_id         = local.base_outputs.account_id
    env                = local.base_outputs.env
    project            = local.base_outputs.project
    name_prefix        = local.base_outputs.name_prefix
    region             = local.base_outputs.region
    vpc_id             = local.base_outputs.vpc_id
    private_subnet_ids = [for s in local.base_outputs.private_subnet_ids : s.id]
    ecs_task_sg_id     = local.base_outputs.sg_ecs_fargate_task.id
  }
}