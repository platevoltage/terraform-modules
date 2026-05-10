terraform {
  cloud {
    organization = "SpaceRocketDev"

    workspaces {
      name    = "Acme1"
      project = "Dev"
    }
  }
}
