variable "vpc_config" {
  description = "VPC module configuration"
  type = object({
    account_id        = string
    env               = string
    project           = string
    aws_region        = string
    name_prefix       = string
    vpc_cidr          = string
    az_count          = number
    flow_logs_enabled = optional(bool, true)
    common_tags       = map(string)
  })
}
