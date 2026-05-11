terraform {
  cloud {
    organization = "SpaceRocketDev"

    workspaces {
      name    = "Acme3"
      project = "Dev"
    }
  }
}
