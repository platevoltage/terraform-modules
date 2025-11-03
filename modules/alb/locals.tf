locals {
  # name_prefix = format("%s-%s", var.project, var.env)
  # alb_name    = format("%s-%s", local.name_prefix, "alb")
  name_prefix = var.network_config.name_prefix
  common_tags = var.network_config.common_tags
  natgw_count = var.network_config.natgw_count == "all" ? var.network_config.az_num : (var.network_config.natgw_count == "one" ? 1 : 0)

  # https://docs.aws.amazon.com/elasticloadbalancing/latest/application/enable-access-logging.html#attach-bucket-policy
  lb_account_id = lookup({
    "us-east-1"    = "127311923021"
    "us-west-1"    = "027434742980"
    "us-west-2"    = "797873946194"
    },
    var.alb_config.aws_region
  )
}
