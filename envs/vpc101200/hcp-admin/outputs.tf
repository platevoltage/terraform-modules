output "project_id" {
  description = "The ID of the Vpc101200 TFC project"
  value       = tfe_project.vpc101200.id
}

output "workspace_ids" {
  description = "Map of workspace keys to their TFC workspace IDs"
  value       = { for k, ws in tfe_workspace.workspaces : k => ws.id }
}

output "workspace_names" {
  description = "Map of workspace keys to their TFC workspace names"
  value       = { for k, ws in tfe_workspace.workspaces : k => ws.name }
}
