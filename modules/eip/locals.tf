locals {
  tags = merge(var.eip_config.common_tags, {
    Name = "${var.eip_config.name_prefix}-strongswan-eip"
  })
}
