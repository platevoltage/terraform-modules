# variable "topic_name" {
#   type = string
# }

# variable "subscriptions" {
#   type    = map(map(string))
#   default = {}
# }

# variable "name_prefix" {
#   type        = string
#   description = "Prefix for naming resources"
# }

# variable "common_tags" {
#   type        = map(string)
#   description = "Common tags to apply to resources"
#   default     = {}
# }
variable "sns_config" {
  type = object({
    account_id = string
    env        = string
    project    = string
    region     = string
    topic_name = string
    name_prefix = string
    subscriptions = map(object({
      protocol = string
      endpoint = string
    }))
    common_tags         = map(string)
  })

  default = {
    account_id = ""
    env        = "dev"
    project    = "default"
    region     = "us-east-1"

    topic_name = "default-ecs-dev-alerts"
    name_prefix = "myapp-dev"
    subscriptions = {
      admin = {
        protocol = "email"
        endpoint = "admin@example.com"
      }
    }
    common_tags         = { Env = "dev", ManagedBy = "terraform", Project = "default" }
  }
}


