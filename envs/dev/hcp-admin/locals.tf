locals {
  organization = "SpaceRocketDev"
  project      = "Dev2"

  workspaces = {
    base_config = {
      name     = "BaseConfig"
      work_dir = "envs/dev/base-config"
    }
    vpc = {
      name     = "VPC"
      work_dir = "envs/dev/vpc"
    }
    transit_gateway = {
      name     = "TransitGateway"
      work_dir = "envs/dev/transit-gateway"
    }
    acme1 = {
      name     = "Acme1"
      work_dir = "envs/dev/clients/acme1"
    }
    acme2 = {
      name     = "Acme2"
      work_dir = "envs/dev/clients/acme2"
    }
    acme3 = {
      name     = "Acme3"
      work_dir = "envs/dev/clients/acme3"
    }
  }

  aws_cred_vars = {
    TFC_AWS_PROVIDER_AUTH              = "true"
    TFC_AWS_WORKLOAD_IDENTITY_AUDIENCE = "aws.workload.identity"
    TFC_AWS_RUN_ROLE_ARN               = var.aws_run_role_arn
  }

  workspace_cred_pairs = {
    for pair in setproduct(keys(local.workspaces), keys(local.aws_cred_vars)) :
    "${pair[0]}__${pair[1]}" => {
      workspace_key = pair[0]
      key           = pair[1]
      value         = local.aws_cred_vars[pair[1]]
    }
  }

  base_config_vars = {
    org        = var.org
    project    = var.project
    env        = var.env
    aws_region = var.aws_region
  }
}
