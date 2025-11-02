resource "aws_cloudwatch_metric_alarm" "unhealthy_instance_count" {
  alarm_name          = format("%s-%s-%s", var.target_group_config.name_prefix, var.target_group_config.tg_name, "unhealthy-instances")
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "UnHealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  period              = "120"
  statistic           = "Average"
  threshold           = "1"
  datapoints_to_alarm = "1"

  dimensions = {
    LoadBalancer = var.target_group_config.alb_arn_suffix
    TargetGroup  = aws_lb_target_group.this.arn_suffix
  }

  alarm_actions = [var.target_group_config.alarm_sns_topic_arn]
}
