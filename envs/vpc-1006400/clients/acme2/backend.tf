terraform {
  cloud {
    organization = "SpaceRocketDev"

    workspaces {
      name    = "Acme2"
      project = "Dev"
    }
  }
}
