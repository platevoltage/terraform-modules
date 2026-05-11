module "eip" {
  source     = "../../../modules/eip"
  eip_config = local.eip_config
}
