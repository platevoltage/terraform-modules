locals {
  account_id              = local.base_config.account_id
  alb_arn_suffix          = local.base_outputs.alb_arn_suffix
  app_name                = var.app_name
  app_names               = local.base_outputs.app_names
  base_config             = data.terraform_remote_state.base.outputs.base_config
  base_outputs            = data.terraform_remote_state.base.outputs.base_outputs
  codebuild_compute_type  = var.codebuild_compute_type
  codebuild_image         = var.codebuild_image
  ecs_cluster_outputs     = data.terraform_remote_state.ecs_cluster.outputs.ecs_cluster_outputs
  fargate_cpu             = var.fargate_cpu
  fargate_ecs_execution_role = local.ecs_cluster_outputs.ecs_execution_role_arn
  fargate_memory          = var.fargate_memory
  fargate_subnets         = local.base_outputs.private_subnet_ids
  git_branch              = var.git_branch
  git_repo                = var.git_repo
  healthcheck_endpoint    = var.healthcheck_endpoint
  image_repo              = var.image_repo
  listener_443_arn        = local.base_outputs.alb_listener_443_arn
  
  # Define path_prefix BEFORE using it
  path_prefix = lookup(
    local.base_outputs.path_prefix_map,
    var.app_name
  )
  
  log_group_name          = "${local.path_prefix}/ecs-service"
  port                    = var.port
  region                  = local.base_config.aws_region
  root_domain             = lookup(local.base_config.fqdn_map, "root", null)
  sns_topic_arn           = local.base_outputs.sns_topic_arn
  
  ssm_secret_path_prefix = lookup(
    local.base_outputs.ssm_secret_path_prefix_map,
    var.app_name,
    local.path_prefix  # Use the defined path_prefix
  )
  
  task_name               = "${local.base_config.name_prefix}-${local.app_name}"
  vpc_id                  = local.base_outputs.vpc_id
  
  # Empty secrets for cloudwatch_exporter (no secrets needed)
  app_secrets             = []
  
  # Environment variables for the container
  app_environments = [
    { name = "AWS_DEFAULT_REGION", value = local.region }
  ]
  # Task role name from ECS service (will be available after service is created)
  fargate_ecs_task_role   = local.ecs_cluster_outputs.ecs_task_role_name
}