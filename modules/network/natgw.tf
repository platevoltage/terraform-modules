resource "aws_eip" "ngw" {
  count  = local.natgw_count
  domain = "vpc"

  depends_on = [aws_internet_gateway.igw]

  tags = merge(local.common_tags, {
    Name = format("%s-natgw-%d", local.name_prefix, count.index + 1)
  })
}

resource "aws_nat_gateway" "ngw" {
  count             = local.natgw_count
  subnet_id         = aws_subnet.public[count.index].id
  allocation_id     = aws_eip.ngw[count.index].id
  connectivity_type = "public"

  depends_on = [aws_internet_gateway.igw]

  tags = merge(local.common_tags, {
    Name = format("%s-%d", local.name_prefix, count.index + 1)
  })
}
