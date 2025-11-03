module "target_group" {
  source              = "../../../modules/tg-fargate"
  target_group_config = local.target_group_config
  # depends_on          = [data.terraform_remote_state.base]
  # priority   = 300
  # source     = "git::https://github.com/space-rocket/terraform-modules.git//06-tg-fargate"
  # account_id = local.account_id
  # env        = local.env
  # project    = local.project
  # region     = local.region

  # vpc_id = local.vpc_id

  # tg_name     = "${var.app_name}-tg"
  # tg_port     = var.port
  # tg_protocol = "HTTP"

  # deregistration_delay = 60

  # health_check_enabled             = true
  # health_check_port                = var.port
  # health_check_protocol            = "HTTP"
  # health_check_path                = "/health"
  # health_check_matcher             = "200-301"
  # health_check_interval            = 30
  # health_check_timeout             = 5
  # health_check_threshold           = 2
  # health_check_unhealthy_threshold = 2

  # listener_443_arn    = local.listener_443_arn
  # alb_arn_suffix      = local.alb_arn_suffix
  # host_headers        = ["${var.app_name}.${local.root_domain}"]
  # alarm_sns_topic_arn = data.terraform_remote_state.infra.outputs.sns_topic_arn

}