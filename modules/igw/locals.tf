locals {
  tags = merge(var.igw_config.common_tags, {
    Name = "${var.igw_config.name_prefix}-igw"
  })
}
