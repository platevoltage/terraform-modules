variable "transit_gateway_config" {
  description = "Transit Gateway module configuration"
  type = object({
    account_id         = string
    env                = string
    project            = string
    aws_region         = string
    name_prefix        = string
    amazon_side_asn    = number
    vpc_id             = string
    private_subnet_ids = list(string)
    flow_logs_enabled  = optional(bool, true)
    common_tags        = map(string)
  })
}
