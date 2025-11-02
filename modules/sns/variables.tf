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


