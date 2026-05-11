locals {
  base_config = data.terraform_remote_state.base_config.outputs.base_config
  tgw_outputs = data.terraform_remote_state.transit_gateway.outputs.transit_gateway_outputs

  client_name = "acme1"

  site_2_site_vpn_config = {
    account_id             = local.base_config.account_id
    env                    = local.base_config.env
    project                = local.base_config.project
    aws_region             = local.base_config.aws_region
    name_prefix            = local.base_config.name_prefix
    client_name            = local.client_name
    transit_gateway_id     = local.tgw_outputs.transit_gateway_id
    transit_gateway_rtb_id = local.tgw_outputs.transit_gateway_route_table_id

    customer_ip_address    = var.customer_ip_address
    customer_cidr          = var.customer_cidr
    customer_ip_address_dr = var.customer_ip_address_dr
    customer_cidr_dr       = var.customer_cidr_dr

    bgp_asn            = var.bgp_asn
    static_routes_only = var.static_routes_only

    tunnel_ike_versions                 = var.tunnel_ike_versions
    tunnel_phase1_integrity_algorithms  = var.tunnel_phase1_integrity_algorithms
    tunnel_phase1_encryption_algorithms = var.tunnel_phase1_encryption_algorithms
    tunnel_phase1_dh_group_numbers      = var.tunnel_phase1_dh_group_numbers
    tunnel_phase2_integrity_algorithms  = var.tunnel_phase2_integrity_algorithms
    tunnel_phase2_encryption_algorithms = var.tunnel_phase2_encryption_algorithms
    tunnel_phase2_dh_group_numbers      = var.tunnel_phase2_dh_group_numbers

    common_tags = merge(local.base_config.common_tags, {
      Client = local.client_name
    })
  }
}
