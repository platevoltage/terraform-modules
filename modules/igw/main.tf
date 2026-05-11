resource "aws_internet_gateway" "this" {
  vpc_id = var.igw_config.vpc_id
  tags   = local.tags
}

resource "aws_route_table" "public" {
  vpc_id = var.igw_config.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = merge(var.igw_config.common_tags, {
    Name = "${var.igw_config.name_prefix}-pub-rt"
  })
}

resource "aws_route_table_association" "public" {
  count          = length(var.igw_config.subnet_ids)
  subnet_id      = var.igw_config.subnet_ids[count.index]
  route_table_id = aws_route_table.public.id
}
