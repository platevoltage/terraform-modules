variable "igw_config" {
  description = "Internet gateway configuration"
  type = object({
    name_prefix = string
    common_tags = map(string)
    vpc_id      = string
    subnet_ids  = list(string)
  })
}
