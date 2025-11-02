# variables.tf
variable "ecs_cluster_config" {
  type = object({
    env                      = string
    account_id               = string
    aws_region               = string
    ssm_secret_path_prefixes = list(string)
    project                  = string
    project_name             = string
    name_prefix              = string
    allowed_ips              = list(string)
    ssh_key_name             = string
    seed_bucket              = string
    common_tags              = map(string)
    cluster_name_override    = string
    ecs_execution_role_arn   = string
  })

  default = {
    env                      = "dev"
    account_id               = "000000000000"
    aws_region               = "NOTSET"
    ssm_secret_path_prefixes = ["/default/"]
    project                  = "default"
    project_name             = "default-dev"
    name_prefix              = "default-dev"
    allowed_ips              = ["0.0.0.0/0"]
    ssh_key_name             = "default-dev-bastion-key"
    seed_bucket              = "default-dev-seed-bucket-000000000000"
    common_tags = {
      Env       = "dev"
      ManagedBy = "terraform"
      Project   = "default"
    }
    cluster_name_override    = ""
    ecs_execution_role_arn   = ""
  }
}
