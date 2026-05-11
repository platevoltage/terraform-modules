locals {
  tags = merge(var.ec2_config.common_tags, {
    Name = var.ec2_config.name
  })
}
