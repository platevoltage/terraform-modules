module "target_group" {
  source              = "../../../modules/tg-fargate"
  target_group_config = local.target_group_config
}