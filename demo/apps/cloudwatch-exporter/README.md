# CloudWatch Exporter

Exports CloudWatch metrics to Prometheus format.

## Local Testing
```bash
cd app
docker build -t my-cw-exporter .
docker run --rm -p 9106:9106 \
  -e AWS_REGION=us-east-1 \
  -e AWS_ACCESS_KEY_ID=your_key \
  -e AWS_SECRET_ACCESS_KEY=your_secret \
  --name cw-exporter my-cw-exporter

# Check metrics
curl http://localhost:9106/metrics
```

## Deploy
```bash
terraform init -backend-config=backend.hcl
terraform plan
terraform apply
```

## Verify
Access metrics: `https://cloudwatch-exporter.obs.hardlineapp.com/metrics`