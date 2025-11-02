data "terraform_remote_state" "base" {
  backend = "s3"
  config = {
    bucket       = "terraform-demo-state-dce2cf761e97"
    key          = "terraform/state/network.tfstate"
    region       = "us-east-2"
    use_lockfile = true
    encrypt      = true
  }
}

data "terraform_remote_state" "ecs_cluster" {
  backend = "s3"
  config = {
    bucket       = "terraform-demo-state-dce2cf761e97"
    key          = "terraform/state/ecs-cluster.tfstate"
    region       = "us-east-2"
    use_lockfile = true
    encrypt      = true
  }
}