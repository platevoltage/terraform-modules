data "terraform_remote_state" "base_config" {
  backend = "remote"
  config = {
    organization = "SpaceRocketDev"
    workspaces = {
      name = "Vpc101200-BaseConfig"
    }
  }
}
