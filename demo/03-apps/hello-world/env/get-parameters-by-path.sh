aws ssm get-parameters-by-path \
  --path /hlaop/prod/prom/ \
  --with-decryption \
  --recursive \
  --query "Parameters[*].[Name,Value]" \
  --output text | sed 's/\/hlaop\/prod\/prom\///' | tr '\t' '=' > .env
