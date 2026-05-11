variable "eip_config" {
  description = "EIP module configuration"
  type = object({
    name_prefix = string
    common_tags = map(string)
  })
}
