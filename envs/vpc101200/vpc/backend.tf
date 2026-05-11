terraform {
  cloud {
    organization = "SpaceRocketDev"

    workspaces {
      name    = "Vpc101200-VPC"
      project = "Vpc101200"
    }
  }
}
