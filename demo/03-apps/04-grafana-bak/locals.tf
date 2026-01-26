data "aws_ssm_parameters_by_path" "all_app_secrets" {
  path            = local.path_prefix
  recursive       = true
  with_decryption = true
}

locals {
  account_id     = local.base_config.account_id
  alb_arn_suffix = local.base_outputs.alb_arn_suffix
  app_name       = var.app_name
  app_names      = local.base_outputs.app_names
  app_environments = [
    { name = "MODE_TYPE", value = "app" },
    { name = "AWS_DEFAULT_REGION", value = local.region }
  ]
 
  app_secrets = concat(
    [
      for path_prefix in local.names : {
        name      = basename(path_prefix)
        valueFrom = path_prefix
      }
    ],
    var.include_secret ? [
      {
        name      = var.aurora_username_name
        valueFrom = var.aurora_username_arn
      },
      {
        name      = var.aurora_password_name
        valueFrom = var.aurora_password_arn
      }
    ] : []
  )

  base_config                = data.terraform_remote_state.base.outputs.base_config
  base_outputs               = data.terraform_remote_state.base.outputs.base_outputs
  codebuild_compute_type     = var.codebuild_compute_type
  codebuild_image            = var.codebuild_image
  ecs_cluster_outputs        = data.terraform_remote_state.ecs_cluster.outputs.ecs_cluster_outputs
  fargate_cpu                = var.fargate_cpu
  fargate_ecs_execution_role = local.ecs_cluster_outputs.ecs_execution_role_arn
  fargate_ecs_task_role      = module.ecs_service.ecs_task_role_name
  fargate_memory             = var.fargate_memory
  fargate_subnets            = local.base_outputs.private_subnet_ids
  git_branch                 = var.git_branch
  git_repo                   = var.git_repo
  healthcheck_endpoint       = var.healthcheck_endpoint
  image_repo                 = var.image_repo
  listener_443_arn           = local.base_outputs.alb_listener_443_arn
  log_group_name             = "${local.path_prefix}/ecs-service"
  names                      = data.aws_ssm_parameters_by_path.all_app_secrets.names
  path_prefix = lookup(
    local.base_outputs.path_prefix_map,
    var.app_name,
    null
  )
  port          = var.port
  region        = local.base_config.aws_region
  root_domain   = lookup(local.base_config.fqdn_map, "root", null)
  sns_topic_arn = local.base_outputs.sns_topic_arn
  ssm_secret_path_prefix = lookup(
    local.base_outputs.ssm_secret_path_prefix_map,
    var.app_name,
    null
  )
  task_name = "${local.base_config.name_prefix}-${local.app_name}"
  vpc_id    = local.base_outputs.vpc_id
}



