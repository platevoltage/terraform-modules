locals {
  name_prefix = var.vpc_config.name_prefix
  common_tags = var.vpc_config.common_tags

  azs = slice(data.aws_availability_zones.available.names, 0, var.vpc_config.az_count)

  private_subnet_cidrs = [
    for i in range(var.vpc_config.az_count) :
    cidrsubnet(var.vpc_config.vpc_cidr, var.vpc_config.subnet_newbits, i + 1)
  ]
}
