resource "aws_subnet" "private" {
  count             = var.vpc_config.az_count
  vpc_id            = aws_vpc.main.id
  cidr_block        = local.private_subnet_cidrs[count.index]
  availability_zone = local.azs[count.index]

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-prv-${local.azs[count.index]}"
  })
}

resource "aws_subnet" "public" {
  count             = var.vpc_config.create_public_subnets ? var.vpc_config.az_count : 0
  vpc_id            = aws_vpc.main.id
  cidr_block        = local.public_subnet_cidrs[count.index]
  availability_zone = local.azs[count.index]

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-pub-${local.azs[count.index]}"
  })
}
