terraform {
  cloud {
    organization = "SpaceRocketDev"

    workspaces {
      name    = "TransitGateway"
      project = "Dev"
    }
  }
}
