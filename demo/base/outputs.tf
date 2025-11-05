output "base_config" {
  value = local.base_config
}

output "base_outputs" {
  description = "All base primitives as a single object"
  value = {
    # === Common Metadata ===
    account_id  = var.account_id
    env         = var.env
    project     = var.project
    aws_region  = var.aws_region
    region      = var.aws_region
    admin_email = var.admin_email
    cert_arn    = var.cert_arn
    allowed_ips = var.allowed_ips
    app_names   = var.app_names
    name_prefix = local.base_config.name_prefix

    # === Network Outputs ===
    vpc_id             = module.network.vpc.id
    public_subnet_ids  = module.network.subnets_public
    private_subnet_ids = module.network.subnets_private


    # === ALB Outputs ===
    alb_listener_443_arn = module.alb.listener_443_arn
    alb_arn_suffix       = module.alb.arn_suffix
    alb_dns_name         = module.alb.alb_dns_name
    alb_arn              = module.alb.alb_arn
    alb_sg_id            = module.alb.alb_sg_id
    # sg_ecs_fargate_task  = module.alb.sg_ecs_fargate_task

    # === SNS Outputs ===
    alarm_sns_topic_arn = module.sns_dev_alerts.topic_arn
    sns_topic_arn       = module.sns_dev_alerts.topic_arn
    sns_topic_name      = module.sns_dev_alerts.topic_name

    # === Locals-Based Outputs ===
    fqdn_map                 = local.base_config.fqdn_map
    ssm_secret_path_prefixes = local.base_config.ssm_secret_path_prefixes
    ssm_secret_path_prefix_map = {
      for idx, app in var.app_names :
      app => local.base_config.ssm_secret_path_prefixes[idx]
    }
    path_prefixes = local.base_config.path_prefixes
    path_prefix_map = {
      for idx, app in var.app_names :
      app => trimsuffix(local.base_config.path_prefixes[idx], "/")
    }


  }
}
