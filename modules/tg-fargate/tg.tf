resource "aws_lb_target_group" "this" {
  name        = format("%s-%s", var.target_group_config.name_prefix, var.target_group_config.tg_name)
  port        = var.target_group_config.tg_port
  protocol    = var.target_group_config.tg_protocol
  vpc_id      = var.target_group_config.vpc_id
  target_type = "ip"

  deregistration_delay = var.target_group_config.deregistration_delay

  health_check {
    port                = var.target_group_config.health_check_port
    protocol            = var.target_group_config.health_check_protocol
    enabled             = var.target_group_config.health_check_enabled
    interval            = var.target_group_config.health_check_interval
    path                = var.target_group_config.health_check_path
    timeout             = var.target_group_config.health_check_timeout
    healthy_threshold   = var.target_group_config.health_check_threshold
    unhealthy_threshold = var.target_group_config.health_check_unhealthy_threshold
    matcher             = var.target_group_config.health_check_matcher
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener_rule" "host" {
  listener_arn = var.target_group_config.listener_443_arn
  priority     = var.target_group_config.priority
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }

  condition {
    host_header {
      values = var.target_group_config.host_headers
    }
  }
}
