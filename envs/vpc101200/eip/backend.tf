terraform {
  cloud {
    organization = "SpaceRocketDev"

    workspaces {
      name    = "Vpc101200-EIP"
      project = "Vpc101200"
    }
  }
}
