data "aws_acm_certificate" "main" {
  domain      = "*.dashtwo.com"
  statuses    = ["ISSUED"]
  most_recent = true
}

