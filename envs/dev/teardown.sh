#!/usr/bin/env bash
set -euo pipefail

TFC_ORG="SpaceRocketDev"
TFC_API="https://app.terraform.io/api/v2"

TFC_TOKEN=$(jq -r '.credentials["app.terraform.io"].token' ~/.terraform.d/credentials.tfrc.json)

POLL_INTERVAL=15

# ── Helpers ───────────────────────────────────────────────────────────────────

get_workspace_id() {
  local name=$1
  local id
  id=$(curl -sf \
    -H "Authorization: Bearer $TFC_TOKEN" \
    "${TFC_API}/organizations/${TFC_ORG}/workspaces/${name}" \
    | jq -r '.data.id')

  if [[ -z "$id" || "$id" == "null" ]]; then
    echo "[error] Workspace '${name}' not found" >&2
    exit 1
  fi
  echo "$id"
}

trigger_destroy() {
  local ws_id=$1
  local ws_name=$2
  echo "[queue] ${ws_name}"
  curl -sf \
    -H "Authorization: Bearer $TFC_TOKEN" \
    -H "Content-Type: application/vnd.api+json" \
    -X POST \
    -d "{
      \"data\": {
        \"attributes\": {
          \"is-destroy\": true,
          \"auto-apply\": true,
          \"message\": \"Teardown via teardown.sh\"
        },
        \"type\": \"runs\",
        \"relationships\": {
          \"workspace\": {
            \"data\": { \"type\": \"workspaces\", \"id\": \"${ws_id}\" }
          }
        }
      }
    }" \
    "${TFC_API}/runs" | jq -r '.data.id'
}

wait_for_run() {
  local run_id=$1
  local ws_name=$2
  local status

  echo "[wait]  ${ws_name} (${run_id})"

  while true; do
    status=$(curl -sf \
      -H "Authorization: Bearer $TFC_TOKEN" \
      "${TFC_API}/runs/${run_id}" \
      | jq -r '.data.attributes.status')

    case "$status" in
      applied|planned_and_finished)
        echo "[done]  ${ws_name} ✓"
        return 0
        ;;
      errored|canceled|discarded|force_canceled)
        echo "[fail]  ${ws_name} — status: ${status}" >&2
        echo "        View run: https://app.terraform.io/app/${TFC_ORG}/runs/${run_id}" >&2
        return 1
        ;;
      needs_confirmation)
        echo "[apply] ${ws_name} — confirming..."
        curl -sf \
          -H "Authorization: Bearer $TFC_TOKEN" \
          -H "Content-Type: application/vnd.api+json" \
          -X POST \
          -d '{"comment": "Auto-confirmed by teardown.sh"}' \
          "${TFC_API}/runs/${run_id}/actions/apply" > /dev/null
        ;;
      *)
        echo "        ${ws_name}: ${status}"
        ;;
    esac

    sleep "$POLL_INTERVAL"
  done
}

destroy_group() {
  local label=$1
  shift
  local workspaces=("$@")

  echo ""
  echo "── ${label} $(printf '─%.0s' {1..50})" | head -c 60
  echo ""

  local -a run_ids=()
  local -a ws_names=()

  for ws_name in "${workspaces[@]}"; do
    local ws_id
    ws_id=$(get_workspace_id "$ws_name")
    local run_id
    run_id=$(trigger_destroy "$ws_id" "$ws_name")
    run_ids+=("$run_id")
    ws_names+=("$ws_name")
  done

  local failed=0
  for i in "${!run_ids[@]}"; do
    wait_for_run "${run_ids[$i]}" "${ws_names[$i]}" || failed=1
  done

  return $failed
}

# ── Teardown ──────────────────────────────────────────────────────────────────

echo ""
echo "╔══════════════════════════════════════╗"
echo "║  Dev environment teardown            ║"
echo "║  Org: ${TFC_ORG}              ║"
echo "╚══════════════════════════════════════╝"

destroy_group "1 — Clients (parallel)"   Acme1 Acme2 Acme3
destroy_group "2 — Transit Gateway"      TransitGateway
destroy_group "3 — VPC"                  VPC
destroy_group "4 — BaseConfig"           BaseConfig

echo ""
echo "══════════════════════════════════════"
echo "  All workspaces destroyed."
echo ""
echo "  To remove the TFC workspaces themselves:"
echo "    cd envs/dev/hcp-admin && terraform destroy"
echo "══════════════════════════════════════"
