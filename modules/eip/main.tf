resource "aws_eip" "this" {
  domain = "vpc"
  tags   = local.tags
}
