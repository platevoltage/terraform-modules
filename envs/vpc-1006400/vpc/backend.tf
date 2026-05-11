terraform {
  cloud {
    organization = "SpaceRocketDev"

    workspaces {
      name    = "VPC"
      project = "Dev"
    }
  }
}
