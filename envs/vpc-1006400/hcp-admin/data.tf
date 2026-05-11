data "tfe_oauth_client" "github" {
  organization     = local.organization
  service_provider = "github"
}
