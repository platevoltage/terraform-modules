module "transit_gateway" {
  source                 = "../../../modules/transit-gateway"
  transit_gateway_config = local.transit_gateway_config
}
