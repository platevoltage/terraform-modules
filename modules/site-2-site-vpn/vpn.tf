locals {
  c = var.site_2_site_vpn_config
}

# ── Primary ───────────────────────────────────────────────────────────────────

resource "aws_customer_gateway" "main" {
  bgp_asn    = local.c.bgp_asn
  ip_address = local.c.customer_ip_address
  type       = "ipsec.1"

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-${local.client_name}-cgw"
  })
}

resource "aws_vpn_connection" "main" {
  transit_gateway_id  = local.c.transit_gateway_id
  customer_gateway_id = aws_customer_gateway.main.id
  type                = "ipsec.1"
  static_routes_only  = local.c.static_routes_only

  tunnel1_ike_versions                 = local.c.tunnel_ike_versions
  tunnel1_phase1_integrity_algorithms  = local.c.tunnel_phase1_integrity_algorithms
  tunnel1_phase1_encryption_algorithms = local.c.tunnel_phase1_encryption_algorithms
  tunnel1_phase1_dh_group_numbers      = local.c.tunnel_phase1_dh_group_numbers
  tunnel1_phase2_integrity_algorithms  = local.c.tunnel_phase2_integrity_algorithms
  tunnel1_phase2_encryption_algorithms = local.c.tunnel_phase2_encryption_algorithms
  tunnel1_phase2_dh_group_numbers      = local.c.tunnel_phase2_dh_group_numbers

  tunnel2_ike_versions                 = local.c.tunnel_ike_versions
  tunnel2_phase1_integrity_algorithms  = local.c.tunnel_phase1_integrity_algorithms
  tunnel2_phase1_encryption_algorithms = local.c.tunnel_phase1_encryption_algorithms
  tunnel2_phase1_dh_group_numbers      = local.c.tunnel_phase1_dh_group_numbers
  tunnel2_phase2_integrity_algorithms  = local.c.tunnel_phase2_integrity_algorithms
  tunnel2_phase2_encryption_algorithms = local.c.tunnel_phase2_encryption_algorithms
  tunnel2_phase2_dh_group_numbers      = local.c.tunnel_phase2_dh_group_numbers

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-${local.client_name}-vpn"
  })
}

resource "aws_ec2_transit_gateway_route" "customer" {
  count                          = local.c.static_routes_only ? 1 : 0
  destination_cidr_block         = local.c.customer_cidr
  transit_gateway_attachment_id  = aws_vpn_connection.main.transit_gateway_attachment_id
  transit_gateway_route_table_id = local.c.transit_gateway_rtb_id
}

# ── DR ────────────────────────────────────────────────────────────────────────

resource "aws_customer_gateway" "dr" {
  bgp_asn    = local.c.bgp_asn
  ip_address = local.c.customer_ip_address_dr
  type       = "ipsec.1"

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-${local.client_name}-cgw-dr"
  })
}

resource "aws_vpn_connection" "dr" {
  transit_gateway_id  = local.c.transit_gateway_id
  customer_gateway_id = aws_customer_gateway.dr.id
  type                = "ipsec.1"
  static_routes_only  = local.c.static_routes_only

  tunnel1_ike_versions                 = local.c.tunnel_ike_versions
  tunnel1_phase1_integrity_algorithms  = local.c.tunnel_phase1_integrity_algorithms
  tunnel1_phase1_encryption_algorithms = local.c.tunnel_phase1_encryption_algorithms
  tunnel1_phase1_dh_group_numbers      = local.c.tunnel_phase1_dh_group_numbers
  tunnel1_phase2_integrity_algorithms  = local.c.tunnel_phase2_integrity_algorithms
  tunnel1_phase2_encryption_algorithms = local.c.tunnel_phase2_encryption_algorithms
  tunnel1_phase2_dh_group_numbers      = local.c.tunnel_phase2_dh_group_numbers

  tunnel2_ike_versions                 = local.c.tunnel_ike_versions
  tunnel2_phase1_integrity_algorithms  = local.c.tunnel_phase1_integrity_algorithms
  tunnel2_phase1_encryption_algorithms = local.c.tunnel_phase1_encryption_algorithms
  tunnel2_phase1_dh_group_numbers      = local.c.tunnel_phase1_dh_group_numbers
  tunnel2_phase2_integrity_algorithms  = local.c.tunnel_phase2_integrity_algorithms
  tunnel2_phase2_encryption_algorithms = local.c.tunnel_phase2_encryption_algorithms
  tunnel2_phase2_dh_group_numbers      = local.c.tunnel_phase2_dh_group_numbers

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-${local.client_name}-vpn-dr"
  })
}

resource "aws_ec2_transit_gateway_route" "customer_dr" {
  count                          = local.c.static_routes_only ? 1 : 0
  destination_cidr_block         = local.c.customer_cidr_dr
  transit_gateway_attachment_id  = aws_vpn_connection.dr.transit_gateway_attachment_id
  transit_gateway_route_table_id = local.c.transit_gateway_rtb_id
}
