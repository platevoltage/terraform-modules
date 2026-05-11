data "terraform_remote_state" "base_config" {
  backend = "remote"
  config = {
    organization = "SpaceRocketDev"
    workspaces = {
      name = "BaseConfig"
    }
  }
}
