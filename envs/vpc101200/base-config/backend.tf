terraform {
  cloud {
    organization = "SpaceRocketDev"

    workspaces {
      name    = "Vpc101200-BaseConfig"
      project = "Vpc101200"
    }
  }
}
