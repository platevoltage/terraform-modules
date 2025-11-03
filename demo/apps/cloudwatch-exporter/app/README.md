# CloudWatch Exporter

Exports CloudWatch metrics to Prometheus format.

## Local Testing
```bash
cd app
docker build -t my-cw-exporter .
docker build -t my-cw-exporter .         
docker run --rm -p 9106:9106 \
  -e AWS_REGION=us-east-1 \
  -e AWS_ACCESS_KEY_ID="xxxx" \
  -e AWS_SECRET_ACCESS_KEY="xxxx" \
  --name cw-exporter my-cw-exporter

# Check metrics
curl http://localhost:9106/metrics
```

```bash
export AWS_REGION=us-east-1
export AWS_ACCOUNT_ID=xxxxxxxx
export ECR_REPO=builtecho/prod/cloudwatch-exporter
export IMAGE_TAG=latest
export ECR_URI="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO}:${IMAGE_TAG}"

aws ecr get-login-password --region ${AWS_REGION} | \
  docker login --username AWS --password-stdin \
  ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com

# 4. Build and push for ARM64 (Fargate)
docker buildx create --use --name cw-exporter-builder 2>/dev/null || true
docker buildx build --platform linux/arm64 -t ${ECR_URI} --push .

# 5. Verify the image was pushed
aws ecr describe-images \
  --repository-name ${ECR_REPO} \
  --region ${AWS_REGION}

echo "Image pushed successfully: ${ECR_URI}"
```


## Deploy
```bash
terraform init -backend-config=backend.hcl
terraform plan
terraform apply
```

## Verify
Access metrics: `https://cloudwatch-exporter.obs.hardlineapp.com/metrics`
```

---

## Where to Create These Files

Create this directory structure:
```
observability/prod/apps/cloudwatch-exporter/
└── app/
    ├── Dockerfile      ← Copy from artifact
    ├── config.yml      ← Copy from artifact
    └── README.md       ← Copy from artifact


```bash
topk(10,
  sum by (function_name) (
    sum_over_time(aws_lambda_invocations_sum[24h])
  )
)
```


```bash
topk(10, sum by (function_name) (sum_over_time(aws_lambda_invocations_sum[24h])))
```