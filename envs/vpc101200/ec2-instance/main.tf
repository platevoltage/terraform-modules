module "ec2_instance" {
  source     = "../../../modules/ec2-instance"
  ec2_config = local.ec2_config
}
