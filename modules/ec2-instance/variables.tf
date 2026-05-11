variable "ec2_config" {
  description = "EC2 instance configuration"
  type = object({
    name              = string
    common_tags       = map(string)
    vpc_id            = string
    subnet_id         = string
    instance_type     = optional(string, "t3.micro")
    eip_allocation_id = string
    user_data         = optional(string, "")
    ingress_rules = optional(list(object({
      description = string
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    })), [])
  })
}
