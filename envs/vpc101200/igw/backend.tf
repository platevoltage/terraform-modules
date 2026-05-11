terraform {
  cloud {
    organization = "SpaceRocketDev"

    workspaces {
      name    = "Vpc101200-IGW"
      project = "Vpc101200"
    }
  }
}
