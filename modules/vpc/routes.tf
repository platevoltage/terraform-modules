resource "aws_route_table" "private" {
  count  = var.vpc_config.az_count
  vpc_id = aws_vpc.main.id

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-prv-rt-${local.azs[count.index]}"
  })
}

resource "aws_route_table_association" "private" {
  count          = var.vpc_config.az_count
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}
