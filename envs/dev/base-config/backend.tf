terraform {
  cloud {
    organization = "SpaceRocketDev"

    workspaces {
      name    = "BaseConfig"
      project = "Dev"
    }
  }
}
