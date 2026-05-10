locals {
  name_prefix = "${var.org}-${var.project}"

  base_config = {
    org         = var.org
    project     = var.project
    env         = var.env
    aws_region  = var.aws_region
    account_id  = data.aws_caller_identity.current.account_id
    name_prefix = local.name_prefix
    common_tags = {
      Env       = var.env
      ManagedBy = "terraform"
      Org       = var.org
      Project   = var.project
    }
  }
}
