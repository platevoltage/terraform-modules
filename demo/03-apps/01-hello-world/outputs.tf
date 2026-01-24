output "outputs_map" {
  description = "Structured application outputs with embedded metadata."
  value = {
    app_name = {
      value       = var.app_name
      description = "Logical application name used for naming and resource scoping."
      version     = "v1"
      since       = "v1"
    }

    app_port = {
      value       = var.port
      description = "Container port exposed by the application."
      version     = "v1"
      since       = "v1"
    }

    deployment_strategy = {
      value       = var.deployment_strategy
      description = "Deployment strategy for the ECS service (rolling or blue_green)."
      version     = "v1"
      since       = "v1"
    }

    healthcheck_endpoint = {
      value       = var.healthcheck_endpoint
      description = "HTTP healthcheck endpoint used by ALB and ECS health checks."
      version     = "v1"
      since       = "v1"
    }

    app_url = {
      value       = local.root_domain != null ? "https://${var.app_name}.${local.root_domain}" : null
      description = "Primary HTTPS URL for the app when root domain is configured in base remote state."
      version     = "v1"
      since       = "v1"
    }

    app_host_header = {
      value       = local.root_domain != null ? "${var.app_name}.${local.root_domain}" : null
      description = "Host header used by the ALB listener rule for routing."
      version     = "v1"
      since       = "v1"
    }

    log_group_name = {
      value       = local.log_group_name
      description = "CloudWatch Logs group name used for ECS task and pipeline logs."
      version     = "v1"
      since       = "v1"
    }

    path_prefix = {
      value       = local.path_prefix
      description = "Base path prefix resolved from base_outputs.path_prefix_map for this app."
      version     = "v1"
      since       = "v1"
    }

    ssm_secret_path_prefix = {
      value       = local.ssm_secret_path_prefix
      description = "SSM Parameter Store secret path prefix resolved from base outputs."
      version     = "v1"
      since       = "v1"
    }

    sns_topic_arn = {
      value       = aws_sns_topic.codepipeline_notifications.arn
      description = "SNS topic ARN for CodePipeline and deployment notifications."
      version     = "v1"
      since       = "v1"
    }

    sns_kms_key_arn = {
      value       = aws_kms_key.sns_topic.arn
      description = "KMS key ARN used to encrypt the SNS topic."
      version     = "v1"
      since       = "v1"
    }

    sns_kms_alias = {
      value       = aws_kms_alias.sns_topic.name
      description = "KMS alias name used for the SNS topic key."
      version     = "v1"
      since       = "v1"
    }

    ecs_cluster_id = {
      value       = local.ecs_cluster_outputs.ecs_cluster_id
      description = "ECS cluster id from remote state."
      version     = "v1"
      since       = "v1"
    }

    ecs_cluster_name = {
      value       = local.ecs_cluster_outputs.ecs_cluster_name
      description = "ECS cluster name from remote state."
      version     = "v1"
      since       = "v1"
    }

    ecs_service_name = {
      value       = module.ecs_service.ecs_service_name
      description = "ECS service name created for this app (rolling or blue_green)."
      version     = "v1"
      since       = "v1"
    }

    ecs_task_definition_arn = {
      value       = module.ecs_service.ecs_task_definition_arn
      description = "ECS task definition ARN for the app."
      version     = "v1"
      since       = "v1"
    }

    ecs_task_role_name = {
      value       = module.ecs_service.ecs_task_role_name
      description = "IAM role name assumed by the ECS task."
      version     = "v1"
      since       = "v1"
    }

    ecs_task_definition_family = {
      value       = module.ecs_service.ecs_task_definition_family
      description = "ECS task definition family for the app."
      version     = "v1"
      since       = "v1"
    }

    ecs_task_definition_revision = {
      value       = module.ecs_service.ecs_task_definition_revision
      description = "ECS task definition revision number for the app."
      version     = "v1"
      since       = "v1"
    }

    task_name = {
      value       = local.task_name
      description = "Task/service name prefix used across resources."
      version     = "v1"
      since       = "v1"
    }

    app_image = {
      value       = local.ecs_service_config.app_image
      description = "Full ECR image reference used by the ECS task definition."
      version     = "v1"
      since       = "v1"
    }

    target_group_blue_arn = {
      value       = module.target_group.tg_arn
      description = "Target group ARN used for production traffic (blue)."
      version     = "v1"
      since       = "v1"
    }

    target_group_blue_name = {
      value       = module.target_group.tg_name
      description = "Target group name used for production traffic (blue)."
      version     = "v1"
      since       = "v1"
    }

    target_group_green_arn = {
      value       = try(module.target_group_green[0].tg_arn, null)
      description = "Target group ARN used for green traffic when deployment_strategy is blue_green."
      version     = "v1"
      since       = "v1"
    }

    target_group_green_name = {
      value       = try(module.target_group_green[0].tg_name, null)
      description = "Target group name used for green traffic when deployment_strategy is blue_green."
      version     = "v1"
      since       = "v1"
    }

    prod_listener_arn = {
      value       = local.listener_443_arn
      description = "ALB HTTPS listener ARN used for production traffic routing."
      version     = "v1"
      since       = "v1"
    }

    test_listener_arn = {
      value       = try(aws_lb_listener.test_8080.arn, null)
      description = "ALB HTTPS test listener ARN used by CodeDeploy for blue_green test traffic."
      version     = "v1"
      since       = "v1"
    }

    codedeploy_app_name = {
      value       = local.deployment_strategy == "blue_green" ? local.codepipeline_config.codedeploy_app : null
      description = "CodeDeploy application name when deployment_strategy is blue_green."
      version     = "v1"
      since       = "v1"
    }

    codedeploy_deployment_group_name = {
      value       = local.deployment_strategy == "blue_green" ? local.codepipeline_config.codedeploy_dg : null
      description = "CodeDeploy deployment group name when deployment_strategy is blue_green."
      version     = "v1"
      since       = "v1"
    }

    git_repo = {
      value       = var.git_repo
      description = "GitHub repository used by the pipeline source action."
      version     = "v1"
      since       = "v1"
    }

    git_branch = {
      value       = var.git_branch
      description = "Git branch used by the pipeline source action."
      version     = "v1"
      since       = "v1"
    }

    image_repo = {
      value       = var.image_repo
      description = "ECR repository name used by the build (repo path only, no registry)."
      version     = "v1"
      since       = "v1"
    }

    image_tag = {
      value       = var.image_tag
      description = "Image tag input used by the service config."
      version     = "v1"
      since       = "v1"
    }
  }
}
