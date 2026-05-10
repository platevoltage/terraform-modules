resource "tfe_project" "dev" {
  organization = local.organization
  name         = local.project
}

resource "tfe_workspace" "workspaces" {
  for_each = local.workspaces

  organization      = local.organization
  project_id        = tfe_project.dev.id
  name              = each.value.name
  working_directory = each.value.work_dir

  auto_apply            = false
  file_triggers_enabled = true
  queue_all_runs        = false
  global_remote_state   = true

  vcs_repo {
    identifier     = "space-rocket/terraform-modules"
    branch         = "v3-dev"
    oauth_token_id = data.tfe_oauth_client.github.oauth_token_id
  }
}

resource "tfe_variable" "aws_dynamic_credentials" {
  for_each = local.workspace_cred_pairs

  workspace_id = tfe_workspace.workspaces[each.value.workspace_key].id
  key          = each.value.key
  value        = each.value.value
  category     = "env"
}

resource "tfe_variable" "base_config_vars" {
  for_each = local.base_config_vars

  workspace_id = tfe_workspace.workspaces["base_config"].id
  key          = each.key
  value        = each.value
  category     = "terraform"
}
