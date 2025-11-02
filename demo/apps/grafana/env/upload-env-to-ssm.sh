#!/usr/bin/env bash
set -euo pipefail

# upload-env-to-ssm.sh
# Upload each key/value in .env to SSM Parameter Store under /hla/obs/prod/graf/ as SecureString

REGION="${AWS_REGION:-us-east-2}"
PROFILE_ARG="${AWS_PROFILE:+--profile $AWS_PROFILE}"

if [ ! -f .env ]; then
  echo "🚨 .env file not found!"
  exit 1
fi

echo "Using region: $REGION ${AWS_PROFILE:+(profile: $AWS_PROFILE)}"

while IFS= read -r line || [ -n "$line" ]; do
  # skip blanks and comments
  [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]] && continue

  # split on first '=' only
  key="${line%%=*}"
  value="${line#*=}"

  # trim
  clean_key="$(echo -n "$key" | xargs)"
  clean_value="$(echo -n "$value" | xargs | sed -e 's/^"//' -e 's/"$//')"

  # skip if no key
  [[ -z "$clean_key" ]] && continue

  param_name="/hla/obs/prod/graf/$clean_key"
  echo "🤐 Uploading $param_name"

  aws ssm put-parameter \
    --name "$param_name" \
    --value "$clean_value" \
    --type SecureString \
    --overwrite \
    --region "$REGION" \
    $PROFILE_ARG
done < .env
