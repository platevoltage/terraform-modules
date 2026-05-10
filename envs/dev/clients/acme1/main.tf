module "site_2_site_vpn" {
  source                 = "../../../../modules/site-2-site-vpn"
  site_2_site_vpn_config = local.site_2_site_vpn_config
}
