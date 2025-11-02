locals {
  acm_config = {
    cert_arn = var.cert_arn
    # base_domain        = var.network_config.base_domain
    # additional_domains = values(local.fqdn_map)
    # aws_region         = var.network_config.aws_region
  }
}