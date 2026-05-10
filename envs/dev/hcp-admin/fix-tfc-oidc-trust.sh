#!/usr/bin/env bash
set -euo pipefail

ROLE_NAME="tfc-dev-workspaces"
TFC_ORG="SpaceRocketDev"

ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
OIDC_PROVIDER_ARN="arn:aws:iam::${ACCOUNT_ID}:oidc-provider/app.terraform.io"

echo "Account ID : ${ACCOUNT_ID}"
echo "Role       : ${ROLE_NAME}"
echo "Updating trust policy to allow any project in ${TFC_ORG}..."

aws iam update-assume-role-policy \
  --role-name "${ROLE_NAME}" \
  --policy-document "{
    \"Version\": \"2012-10-17\",
    \"Statement\": [{
      \"Effect\": \"Allow\",
      \"Principal\": { \"Federated\": \"${OIDC_PROVIDER_ARN}\" },
      \"Action\": \"sts:AssumeRoleWithWebIdentity\",
      \"Condition\": {
        \"StringEquals\": { \"app.terraform.io:aud\": \"aws.workload.identity\" },
        \"StringLike\": { \"app.terraform.io:sub\": \"organization:${TFC_ORG}:project:*:workspace:*:run_phase:*\" }
      }
    }]
  }"

echo "Done. Trust policy updated — retry terraform apply in base-config."
