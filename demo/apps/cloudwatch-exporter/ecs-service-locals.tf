locals {
  ecs_service_config = merge(
    local.base_config,
    {
      app_count = 1
      app_environments = [
        { name = "AWS_DEFAULT_REGION", value = local.region }
      ]
      app_image                  = "${local.account_id}.dkr.ecr.${local.region}.amazonaws.com/${var.image_repo}:${var.image_tag}"
      app_name                   = local.app_name
      app_names                  = local.app_names
      app_port                   = var.port
      app_secrets                = local.app_secrets
      assign_public_ip           = false
      ecs_cluster_id             = local.ecs_cluster_outputs.ecs_cluster_id
      ecs_cluster_name           = local.ecs_cluster_outputs.ecs_cluster_name
      ecs_execution_role         = local.ecs_cluster_outputs.ecs_execution_role_arn
      fargate_cpu                = var.fargate_cpu
      fargate_memory             = var.fargate_memory
      fargate_subnets            = local.fargate_subnets
      healthcheck_endpoint       = var.healthcheck_endpoint
      healthcheck_interval       = 10
      healthcheck_retries        = 5
      healthcheck_start_period   = 60
      healthcheck_timeout        = 10
      listener_443_arn           = local.listener_443_arn
      log_group_name             = local.log_group_name
      path_prefix                = local.path_prefix
      path_prefix_map            = local.base_outputs.path_prefix_map
      region                     = local.region
      runtime_platform           = "ARM64"
      ssm_secret_path_prefix     = local.path_prefix
      ssm_secret_path_prefix_map = local.base_outputs.ssm_secret_path_prefix_map
      task_name                  = local.task_name
      tg_arn                     = module.target_group.tg_arn
    }
  )
}