# PRIVATE
resource "aws_route_table" "private" {
  count = length(aws_subnet.private)

  vpc_id = aws_vpc.main.id

  tags = merge(local.common_tags, {
    Name = format("%s-private-%s",
      local.name_prefix,
      substr(strrev(element(data.aws_availability_zones.az.names, count.index)), 0, 1)
    )
  })
}

resource "aws_route_table_association" "private" {
  count = length(aws_subnet.private)

  subnet_id      = element(aws_subnet.private[*].id, count.index)
  route_table_id = element(aws_route_table.private[*].id, count.index)
}

resource "aws_route" "private_natgw" {
  count = local.natgw_count == 0 ? 0 : length(aws_route_table.private)

  route_table_id         = element(aws_route_table.private[*].id, count.index)
  destination_cidr_block = "0.0.0.0/0"

  nat_gateway_id = local.natgw_count == 0 ? 0 : (
    local.natgw_count == 1 ? aws_nat_gateway.ngw[0].id : element(aws_nat_gateway.ngw[*].id, count.index)
  )
}

# PUBLIC

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-public"
  })
}

resource "aws_route_table_association" "public" {
  count = length(aws_subnet.public)

  subnet_id      = element(aws_subnet.public[*].id, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_route" "route_public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}


# SSM VPC ENDPOINTS

data "aws_region" "current" {}

resource "aws_vpc_endpoint" "ssm" {
  vpc_id = aws_vpc.main.id

  service_name = "com.amazonaws.${data.aws_region.current.name}.ssm"

  vpc_endpoint_type = "Interface"

  private_dns_enabled = true

  subnet_ids = aws_subnet.public[*].id

  security_group_ids = [
    aws_security_group.ssm_endpoint.id
  ]

  tags = local.common_tags
}

resource "aws_vpc_endpoint" "ssmmessages" {
  vpc_id = aws_vpc.main.id

  service_name = "com.amazonaws.${data.aws_region.current.name}.ssmmessages"

  vpc_endpoint_type = "Interface"

  private_dns_enabled = true

  subnet_ids = aws_subnet.public[*].id

  security_group_ids = [
    aws_security_group.ssm_endpoint.id
  ]

  tags = local.common_tags
}