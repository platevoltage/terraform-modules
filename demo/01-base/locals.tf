locals {
  name_prefix = "${var.org}-${var.project}-${var.env}"
  logs_bucket = "${local.name_prefix}-alb-logs"
  app_path    = "${var.org}/${var.project}/${var.env}"

  fqdn_map = {
    for app in var.app_names :
    app != "" ? app : "root" => app != "" ? "${app}.${var.base_domain}" : var.base_domain
  }

  base_config = {
    account_id                = var.account_id
    base_domain               = var.base_domain
    project                   = var.project
    project_name              = "${var.project}-${var.env}"
    name_prefix               = local.name_prefix
    env                       = var.env
    aws_region                = var.aws_region
    lb_ssl_policy             = "ELBSecurityPolicy-TLS13-1-3-FIPS-2023-04"
    main_domain               = var.base_domain
    additional_domains        = values(local.fqdn_map)
    fqdn_map                  = local.fqdn_map
    logs_enabled              = true
    logs_prefix               = var.env
    logs_bucket               = "${local.logs_bucket}"
    logs_expiration           = 90
    logs_bucket_force_destroy = false
    alb_5xx_threshold         = 20
    target_5xx_threshold      = 20
    topic_name                = "${local.name_prefix}-ecs-alerts"
    allowed_ips               = var.allowed_ips
    natgw_count               = var.natgw_count

    ssm_secret_path_prefixes = [
      for app in var.app_names :
      "arn:aws:ssm:${var.aws_region}:${var.account_id}:parameter/${local.app_path}/${app}"
    ]

    # just a list of prefixes
    path_prefixes = [
      for app in var.app_names :
      "/${local.app_path}/${app}"
    ]

    common_tags = {
      Env       = var.env
      ManagedBy = "terraform"
      Project   = var.project
    }
  }

  network_config = {
    account_id   = local.base_config.account_id
    env          = local.base_config.env
    project      = local.base_config.project
    aws_region   = local.base_config.aws_region
    base_domain  = local.base_config.base_domain
    project_name = local.base_config.project_name
    name_prefix  = local.base_config.name_prefix

    az_num              = 3
    vpc_ip_block        = "172.27.72.0/22"
    subnet_cidr_private = "172.27.72.0/24"
    subnet_cidr_public  = "172.27.73.0/24"
    new_bits_private    = 2
    new_bits_public     = 2
    natgw_count         = local.base_config.natgw_count

    public_ips = {
      for ip in var.allowed_ips :
      "${ip}/32" => "Allowed IP"
      if !can(regex("/", ip))
    }

    public_ips_v6 = {}

    app_ports = [
      80,
      443,
    ]

    common_tags = local.base_config.common_tags
  }
}
