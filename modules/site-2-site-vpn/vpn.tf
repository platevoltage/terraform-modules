resource "aws_customer_gateway" "main" {
  bgp_asn    = var.site_2_site_vpn_config.bgp_asn
  ip_address = var.site_2_site_vpn_config.customer_ip_address
  type       = "ipsec.1"

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-${local.client_name}-cgw"
  })
}

resource "aws_vpn_connection" "main" {
  transit_gateway_id  = var.site_2_site_vpn_config.transit_gateway_id
  customer_gateway_id = aws_customer_gateway.main.id
  type                = "ipsec.1"
  static_routes_only  = var.site_2_site_vpn_config.static_routes_only

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-${local.client_name}-vpn"
  })
}

# Only needed for static routing — BGP propagates routes automatically
resource "aws_ec2_transit_gateway_route" "customer" {
  count                          = var.site_2_site_vpn_config.static_routes_only ? 1 : 0
  destination_cidr_block         = var.site_2_site_vpn_config.customer_cidr
  transit_gateway_attachment_id  = aws_vpn_connection.main.transit_gateway_attachment_id
  transit_gateway_route_table_id = var.site_2_site_vpn_config.transit_gateway_rtb_id
}
