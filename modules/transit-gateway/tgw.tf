resource "aws_ec2_transit_gateway" "main" {
  description                     = "${local.name_prefix} transit gateway"
  amazon_side_asn                 = var.transit_gateway_config.amazon_side_asn
  default_route_table_association = "enable"
  default_route_table_propagation = "enable"
  vpn_ecmp_support                = "enable"
  dns_support                     = "enable"

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-tgw"
  })
}

resource "aws_ec2_transit_gateway_vpc_attachment" "main" {
  transit_gateway_id = aws_ec2_transit_gateway.main.id
  vpc_id             = var.transit_gateway_config.vpc_id
  subnet_ids         = var.transit_gateway_config.private_subnet_ids

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-tgw-vpc-attach"
  })
}
