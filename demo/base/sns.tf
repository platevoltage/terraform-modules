module "sns_dev_alerts" {
  source = "../../modules/sns"
  sns_config = {
    account_id  = local.base_config.account_id
    env         = local.base_config.env
    project     = local.base_config.project
    region      = local.base_config.aws_region
    name_prefix = local.base_config.name_prefix
    common_tags = local.base_config.common_tags

    topic_name = local.base_config.topic_name

    subscriptions = {
      admin = {
        protocol = "email"
        endpoint = var.admin_email
      }
    }

  }
}
