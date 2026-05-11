module "igw" {
  source     = "../../../modules/igw"
  igw_config = local.igw_config
}
