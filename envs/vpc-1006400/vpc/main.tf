module "vpc" {
  source     = "../../../modules/vpc"
  vpc_config = local.vpc_config
}
