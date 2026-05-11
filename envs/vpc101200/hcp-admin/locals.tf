locals {
  organization = "SpaceRocketDev"
  project      = "Vpc101200"

  workspaces = {
    base_config = {
      name     = "Vpc101200-BaseConfig"
      work_dir = "envs/vpc101200/base-config"
    }
    vpc = {
      name     = "Vpc101200-VPC"
      work_dir = "envs/vpc101200/vpc"
    }
    igw = {
      name     = "Vpc101200-IGW"
      work_dir = "envs/vpc101200/igw"
    }
    eip = {
      name     = "Vpc101200-EIP"
      work_dir = "envs/vpc101200/eip"
    }
    ec2_instance = {
      name     = "Vpc101200-EC2Instance"
      work_dir = "envs/vpc101200/ec2-instance"
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
