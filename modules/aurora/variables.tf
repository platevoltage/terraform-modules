variable "aurora_config" {
  description = "Configuration object for the Aurora PostgreSQL cluster"
  type = object({
    account_id         = string
    db_name            = string
    admin_email        = string
    name_prefix        = string
    env                = string
    project            = string
    region             = string
    vpc_id             = string
    private_subnet_ids = list(string)
    ecs_task_sg_id     = string
  })

  default = {
    account_id         = ""
    db_name            = ""
    admin_email        = ""
    name_prefix        = ""
    env                = ""
    project            = ""
    region             = ""
    vpc_id             = ""
    private_subnet_ids = []
    ecs_task_sg_id     = ""
  }
}