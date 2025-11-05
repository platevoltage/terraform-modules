variable "ecs_service_config" {
  type = object({
    account_id                 = string
    app_count                  = number
    app_environments           = list(object({ name = string, value = string }))
    app_image                  = string
    app_name                   = string
    app_names                  = list(string)
    app_port                   = number
    app_secrets                = list(object({ name = string, valueFrom = string }))
    assign_public_ip           = optional(bool, true)
    env                        = string
    ecs_cluster_id             = string
    ecs_execution_role         = string
    fargate_cpu                = number
    fargate_memory             = number
    fargate_subnets            = list(any)
    healthcheck_endpoint       = string
    healthcheck_interval       = number
    healthcheck_retries        = number
    healthcheck_start_period   = number
    healthcheck_timeout        = number
    log_group_name             = string
    path_prefix_map            = map(string)
    project                    = string
    region                     = string
    runtime_platform           = string
    ssm_secret_path_prefix_map = map(string)
    task_name                  = string
    tg_arn                     = string
    name_prefix                = string
    common_tags                = map(string)
    vpc_id                     = string
  })

  default = {
    account_id                 = ""
    app_count                  = 1
    app_environments           = []
    app_image                  = "123456789012.dkr.ecr.us-east-1.amazonaws.com/app:latest"
    app_name                   = "my_app"
    app_names                  = []
    app_port                   = 8080
    app_secrets                = []
    env                        = "dev"
    ecs_cluster_id             = ""
    ecs_execution_role         = ""
    fargate_cpu                = 256
    fargate_memory             = 512
    fargate_subnets            = []
    healthcheck_endpoint       = "/health"
    healthcheck_interval       = 30
    healthcheck_retries        = 3
    healthcheck_start_period   = 60
    healthcheck_timeout        = 5
    log_group_name             = "/ecs/app"
    path_prefix_map            = {}
    project                    = "default"
    region                     = ""
    runtime_platform           = ""
    ssm_secret_path_prefix_map = {}
    task_name                  = "app"
    tg_arn                     = ""
    name_prefix                = ""
    common_tags                = {}
    vpc_id                     = ""
  }
}
