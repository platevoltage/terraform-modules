module "acm_certs" {
  source     = "../../modules/acm"
  acm_config = local.acm_config
  # base_domain        = var.network_config.base_domain
  # additional_domains = values(local.fqdn_map)
  # aws_region         = var.network_config.aws_region
}
