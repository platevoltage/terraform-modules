variable "vpc_config" {
  description = "VPC module configuration"
  type = object({
    account_id  = string
    env         = string
    project     = string
    aws_region  = string
    name_prefix = string
    vpc_cidr    = string
    az_count    = number
    common_tags = map(string)
  })
}
