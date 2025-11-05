# Lightweight HTTP listener for CodeDeploy test traffic
resource "aws_lb_listener" "test_8080" {
  load_balancer_arn = local.base_outputs.alb_arn
  port              = 8080
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      status_code  = "200"
      message_body = "test-listener"
    }
  }
}
