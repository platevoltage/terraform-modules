module "alb" {
  source         = "../../modules/alb"
  network_config = local.network_config
  alb_config = {
    account_id                = local.base_config.account_id
    env                       = local.base_config.env
    project                   = local.base_config.project
    name_prefix               = local.base_config.name_prefix
    aws_region                = local.base_config.aws_region
    vpc                       = module.network.vpc
    lb_subnets                = module.network.subnets_public
    lb_sg                     = "deprecating"
    lb_ssl_policy             = "ELBSecurityPolicy-2016-08"
    main_domain               = var.base_domain
    additional_domains        = values(local.fqdn_map)
    logs_enabled              = true
    logs_prefix               = var.env
    logs_bucket               = "${local.logs_bucket}"
    logs_expiration           = 90
    logs_bucket_force_destroy = false
    alb_5xx_threshold         = 20
    target_5xx_threshold      = 20

    main_cert_arn = var.cert_arn
    # remove this extra key; the module does not define it:
    # additional_cert_arns = var.additional_cert_arn

    create_aliases = [
      for app, fqdn in local.fqdn_map : {
        name = fqdn
        zone = var.base_domain
      }
    ]

    common_tags         = local.base_config.common_tags
    alarm_sns_topic_arn = module.sns_dev_alerts.topic_arn
    nat_gateway_eips    = module.network.nat_gateway_eips # ← This passes the EIPs!
  }
}
