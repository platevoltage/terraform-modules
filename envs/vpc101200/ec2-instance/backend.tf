terraform {
  cloud {
    organization = "SpaceRocketDev"

    workspaces {
      name    = "Vpc101200-EC2Instance"
      project = "Vpc101200"
    }
  }
}
