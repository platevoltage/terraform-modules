locals {
  codepipeline_config = merge(
    local.base_config,
    local.ecs_cluster_outputs,
    {
      app_name                   = local.app_name
      app_secrets                = local.app_secrets
      app_environments           = local.app_environments
      codebuild_compute_type     = local.codebuild_compute_type
      codebuild_image            = local.codebuild_image
      ecs_service_name           = module.ecs_service.ecs_service_name
      fargate_cpu                = local.fargate_cpu
      fargate_ecs_execution_role = local.fargate_ecs_execution_role
      fargate_ecs_task_role      = local.fargate_ecs_task_role
      fargate_memory             = local.fargate_memory
      git_branch                 = local.git_branch
      git_repo                   = local.git_repo
      healthcheck_endpoint       = local.healthcheck_endpoint
      image_repo                 = local.image_repo
      log_group_name             = local.log_group_name
      port                       = local.port
      region                     = local.region
      ssm_secret_path_prefix     = local.ssm_secret_path_prefix
      task_name                  = local.task_name
      deploy_provider            = "ECS"
      # Blue/Green
      # deploy_provider            = "CodeDeployToECS" 
    }
  )
}
