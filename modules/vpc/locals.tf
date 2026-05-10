locals {
  name_prefix = var.vpc_config.name_prefix
  common_tags = var.vpc_config.common_tags

  private_subnet_cidrs = [
    for i in range(var.vpc_config.az_count) :
    cidrsubnet(var.vpc_config.vpc_cidr, 8, i + 1)
  ]
}
