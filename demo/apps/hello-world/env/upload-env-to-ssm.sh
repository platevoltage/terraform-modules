#!/bin/bash
# IMPORTANT! Be sure to use correct param_name
# upload-env-to-ssm.sh
# 🚀 Uploads each key/value in .env to SSM Parameter Store under /hlaobs/prod/prom/ as SecureString

# Ensure .env exists
if [ ! -f .env ]; then
  echo "🚨 .env file not found!"
  exit 1
fi

# Read .env line by line
while IFS='=' read -r key value; do
  # Skip empty lines and comments
  if [[ -z "$key" || "$key" == \#* ]]; then
    continue
  fi

  # Strip quotes and whitespace
  clean_key=$(echo "$key" | xargs)
  clean_value=$(echo "$value" | xargs | sed -e 's/^"//' -e 's/"$//')

  # Build parameter name
  param_name="/hlaobs/prod/prom/$clean_key"

  echo "🤐 Uploading $param_name"

  aws ssm put-parameter \
    --name "$param_name" \
    --value "$clean_value" \
    --type "SecureString" \
    --overwrite

done < .env
