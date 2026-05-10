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

  client_workspace_vars = {
    acme1 = {
      customer_ip_address    = "203.0.113.1"     # replace with real acme1 primary VPN IP
      customer_cidr          = "100.65.0.0/17"
      customer_ip_address_dr = "203.0.113.2"     # replace with real acme1 DR VPN IP
      customer_cidr_dr       = "100.65.128.0/17"
    }
    acme2 = {
      customer_ip_address    = "203.0.113.11"    # replace with real acme2 primary VPN IP
      customer_cidr          = "100.66.0.0/17"
      customer_ip_address_dr = "203.0.113.12"    # replace with real acme2 DR VPN IP
      customer_cidr_dr       = "100.66.128.0/17"
    }
    acme3 = {
      customer_ip_address    = "203.0.113.21"    # replace with real acme3 primary VPN IP
      customer_cidr          = "100.67.0.0/17"
      customer_ip_address_dr = "203.0.113.22"    # replace with real acme3 DR VPN IP
      customer_cidr_dr       = "100.67.128.0/17"
    }
  }

  client_var_pairs = {
    for pair in flatten([
      for ws_key, vars in local.client_workspace_vars : [
        for var_key, var_val in vars : {
          ws_key  = ws_key
          var_key = var_key
          var_val = var_val
        }
      ]
    ]) :
    "${pair.ws_key}__${pair.var_key}" => pair
  }
}
