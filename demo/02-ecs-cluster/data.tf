# observability/prod/ecs-cluster/data.tf
# Consumes outputs from the Base Module Group
data "terraform_remote_state" "base" {
  backend = "s3"
  config = {
    bucket       = "terraform-demo-state-dce2cf761e97"
    key          = "terraform/state/network.tfstate"
    region       = "us-east-1"
    use_lockfile = true
    encrypt      = true
  }
}
