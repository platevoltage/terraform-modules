module "aurora" {
  source        = "../../modules/aurora"
  aurora_config = local.aurora_config
}