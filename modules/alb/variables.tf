variable "alb_config" {
  type = object({
    account_id                = string
    env                       = string
    project                   = string
    name_prefix               = string
    aws_region                = string
    vpc                       = any
    lb_subnets                = list(any)
    lb_sg                     = any
    lb_ssl_policy             = string
    main_domain               = string
    additional_domains        = list(string)
    logs_enabled              = bool
    logs_prefix               = string
    logs_bucket               = string
    logs_expiration           = number
    logs_bucket_force_destroy = bool
    main_cert_arn             = string
    create_aliases            = list(object({
      name = string
      zone = string
    }))
    common_tags            = map(string)
    target_5xx_threshold   = optional(number, 20)
    alb_5xx_threshold      = optional(number, 20)
    alarm_sns_topic_arn    = string

    logs_access_enabled            = optional(bool, true)
    logs_access_bucket             = optional(string, null)
    logs_access_prefix             = optional(string, "s3-access-logs/")
    logs_access_bucket_force_destroy = optional(bool, false)
    logs_access_expiration         = optional(number, 365)
    nat_gateway_eips               = optional(list(string), []) 
  })

  default = {
    account_id  = ""
    env         = "dev"
    project     = "default"
    name_prefix = "myapp-dev"
    aws_region  = "us-east-1"

    vpc        = null
    lb_subnets = []
    lb_sg      = null

    lb_ssl_policy             = "ELBSecurityPolicy-2016-08"
    main_domain               = "example.com"
    additional_domains        = []
    logs_enabled              = true
    logs_prefix               = "dev"
    logs_bucket               = "default-dev-ecs-alb-logs"
    logs_expiration           = 90
    logs_bucket_force_destroy = false
    main_cert_arn             = ""

    create_aliases = []
    common_tags    = { Env = "dev", ManagedBy = "terraform", Project = "default" }
    alb_5xx_threshold    = 20
    target_5xx_threshold = 20
    alarm_sns_topic_arn  = ""

    logs_access_enabled              = true
    logs_access_bucket               = null        # if null, a name will be derived below
    logs_access_prefix               = "s3-access-logs/"
    logs_access_bucket_force_destroy = false
    logs_access_expiration           = 365
    nat_gateway_eips                 = []
  }
}
variable "network_config" {
  type = object({
    project_name        = string
    name_prefix         = string
    base_domain         = string
    account_id          = string
    env                 = string
    project             = string
    aws_region          = string
    az_num              = number
    vpc_ip_block        = string
    subnet_cidr_private = string
    subnet_cidr_public  = string
    new_bits_private    = number
    new_bits_public     = number
    natgw_count         = string
    public_ips          = map(string)
    public_ips_v6       = map(string)
    app_ports           = list(number)
    common_tags         = map(string)
  })

  default = {
    project_name        = "myapp-dev"
    name_prefix         = "myapp-dev"
    base_domain         = "example.com"
    account_id          = ""
    env                 = "dev"
    project             = "default"
    aws_region          = "us-east-1"
    az_num              = 3
    vpc_ip_block        = "172.27.72.0/22"
    subnet_cidr_private = "172.27.72.0/24"
    subnet_cidr_public  = "172.27.73.0/24"
    new_bits_private    = 2
    new_bits_public     = 2
    natgw_count         = "none"
    public_ips          = { "0.0.0.0/0" = "Open" }
    public_ips_v6       = { "::/0" = "Open" }
    app_ports           = [80, 443]
    common_tags         = { Env = "dev", ManagedBy = "terraform", Project = "default" }

  }
}
