locals {
  deployment_strategy = var.deployment_strategy
}

locals {
  ecs_service_config = merge(
    local.base_config,
    {
      app_count = 1
      app_environments = [
        { name = "MODE_TYPE", value = "app" },
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
      name_prefix                = local.base_outputs.name_prefix
      common_tags                = local.base_config.common_tags
      vpc_id                     = local.base_outputs.vpc_id

      # rolling input
      tg_arn = module.target_group.tg_arn

      # strategy inputs
      deployment_strategy = local.deployment_strategy

      # blue green extras
      blue_tg_arn       = try(module.target_group.tg_arn, "")
      green_tg_arn      = try(module.target_group_green[0].tg_arn, "")

      # add names so CodeDeploy can rely on them even if an ARN is empty
      blue_tg_name      = try(module.target_group.tg_name, "")
      green_tg_name     = try(module.target_group_green[0].tg_name, "")

      prod_listener_arn = local.listener_443_arn
      # Use a distinct listener for test traffic when blue_green
      test_listener_arn = var.deployment_strategy == "blue_green" ? aws_lb_listener.test_8080.arn : null

      deploy_provider            = local.deployment_strategy == "blue_green" ? "CodeDeployToECS" : "ECS"
      codedeploy_app             = local.deployment_strategy == "blue_green" ? "${local.task_name}-cd-app" : null
      codedeploy_dg              = local.deployment_strategy == "blue_green" ? "${local.task_name}-cd-dg"  : null
      alb_sg_id                  = local.base_outputs.alb_sg_id
    }
  )
}
