# data "aws_ssm_parameters_by_path" "all_app_secrets" {
#   path            = local.path_prefix
#   recursive       = true
#   with_decryption = true
# }

# # path_prefix :
# # "/dt/dev/api"

# locals {
#   base_config                = data.terraform_remote_state.base.outputs.base_config
#   base_outputs               = data.terraform_remote_state.base_outputs

#   root_domain                = lookup(local.base_config.fqdn_map, "root", null)
#   region                     = local.base_config.aws_region
#   account_id                 = local.base_config.account_id
#   log_group_name             = "${local.path_prefix}/ecs-service"

#   app_name        = var.app_name
#   task_name       = "${local.base_config.name_prefix}-${local.app_name}"
#   all_app_secrets = local.names
#   app_secrets = [
#     for path_prefix in local.names : {
#       name      = basename(path_prefix)
#       valueFrom = path_prefix
#     }
#   ]

#   path_prefix = lookup(
#     local.path_prefix_map,
#     var.app_name,
#     null
#   )

#   ssm_secret_path_prefix = lookup(
#     local.ssm_secret_path_prefix_map,
#     var.app_name,
#     null
#   )

#   this_config = {
#     git_repo                   = var.git_repo
#     git_branch                 = var.git_branch
#     port                       = var.port
#     image_repo                 = var.image_repo
#     codebuild_compute_type     = var.codebuild_compute_type
#     codebuild_image            = var.codebuild_image
#     fargate_cpu                = var.fargate_cpu
#     fargate_memory             = var.fargate_memory
#     healthcheck_endpoint       = var.healthcheck_endpoint
#     app_name                   = local.app_name
#     task_name                  = local.task_name
#     # root_domain                = lookup(local.base_config.fqdn_map, "root", null)

#     all_app_secrets            = local.all_app_secrets
#     app_secrets                = local.app_secrets
#     path_prefix_map            = local.path_prefix_map
#     path_prefix                = local.path_prefix
#     ssm_secret_path_prefix_map = local.ssm_secret_path_prefix_map
#     ssm_secret_path_prefix     = local.ssm_secret_path_prefix
#     sns_topic_arn              = aws_sns_topic.codepipeline_notifications.arn
#     runtime_platform           = "ARM64"
#     ecs_execution_role         = local.ecs_cluster_outputs.ecs_execution_role_arn
#   }
# }


