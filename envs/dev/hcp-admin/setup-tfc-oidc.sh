#!/usr/bin/env bash
set -euo pipefail

ROLE_NAME="tfc-dev-workspaces"
TFC_ORG="SpaceRocketDev"
TFC_PROJECT="Dev"
TFC_THUMBPRINT="9e99a48a9960b14926bb7f3b02e22da2b0ab7280"

ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
OIDC_PROVIDER_ARN="arn:aws:iam::${ACCOUNT_ID}:oidc-provider/app.terraform.io"

echo "Account ID : ${ACCOUNT_ID}"
echo "Role name  : ${ROLE_NAME}"
echo ""

# ── 1. OIDC provider ──────────────────────────────────────────────────────────
if aws iam get-open-id-connect-provider --open-id-connect-provider-arn "${OIDC_PROVIDER_ARN}" &>/dev/null; then
  echo "[skip] OIDC provider already exists"
else
  echo "[create] OIDC provider for app.terraform.io"
  aws iam create-open-id-connect-provider \
    --url https://app.terraform.io \
    --client-id-list aws.workload.identity \
    --thumbprint-list "${TFC_THUMBPRINT}"
fi

# ── 2. Trust policy ───────────────────────────────────────────────────────────
TRUST_POLICY=$(cat <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "${OIDC_PROVIDER_ARN}"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "app.terraform.io:aud": "aws.workload.identity"
        },
        "StringLike": {
          "app.terraform.io:sub": "organization:${TFC_ORG}:project:*:workspace:*:run_phase:*"
        }
      }
    }
  ]
}
EOF
)

# ── 3. IAM role ───────────────────────────────────────────────────────────────
if aws iam get-role --role-name "${ROLE_NAME}" &>/dev/null; then
  echo "[skip] IAM role ${ROLE_NAME} already exists"
else
  echo "[create] IAM role ${ROLE_NAME}"
  aws iam create-role \
    --role-name "${ROLE_NAME}" \
    --assume-role-policy-document "${TRUST_POLICY}" \
    --description "Assumed by TFC workspaces in ${TFC_ORG}/${TFC_PROJECT} via OIDC"
fi

# ── 4. Permissions ────────────────────────────────────────────────────────────
echo "[attach] AdministratorAccess (scope down to least-privilege later)"
aws iam attach-role-policy \
  --role-name "${ROLE_NAME}" \
  --policy-arn arn:aws:iam::aws:policy/AdministratorAccess

# ── 5. Done ───────────────────────────────────────────────────────────────────
ROLE_ARN=$(aws iam get-role --role-name "${ROLE_NAME}" --query Role.Arn --output text)

echo ""
echo "Done. Set this as the aws_run_role_arn variable in the hcp-admin TFC workspace:"
echo ""
echo "  ${ROLE_ARN}"
echo ""
echo "Then re-apply hcp-admin to push TFC_AWS_RUN_ROLE_ARN to all workspaces."
