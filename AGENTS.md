# AWS Infrastructure Instructions

## Project

This repository manages AWS infrastructure for a production
microservice platform.

Current platform:

- ECS/Fargate
- 20+ services
- CloudFront
- AWS WAF
- Application Load Balancers
- RDS
- RDS Proxy
- Route 53
- S3
- SQS
- Secrets Manager
- SSM Parameter Store
- CloudWatch

Future platform:
- EKS/Kubernetes

## Environments

- dev
- staging
- prod

## Production rules

NEVER run destructive AWS commands against production without
explicit approval.

NEVER:
- delete an ALB
- delete an RDS instance
- delete an ECS service
- destroy a Terraform resource
- modify production DNS
- promote an RDS replica
- modify production security groups

without first showing:
1. what will change
2. why it is needed
3. impact
4. rollback plan

## Terraform rules

Before considering a Terraform change complete:

terraform fmt
terraform validate
terraform plan

Never use terraform apply automatically for production.

## AWS rules

Prefer least-privilege IAM.

Never hard-code:
- passwords
- secrets
- access keys
- tokens
- database credentials

Use:
- Secrets Manager
- SSM Parameter Store
- IAM roles

## Networking

Production architecture:

CloudFront
  ->
WAF
  ->
VPC Origin
  ->
Internal ALB
  ->
ECS
  ->
RDS

ALBs should not be made public unless explicitly requested.

## Logging

Application:
stdout/stderr
  ->
CloudWatch Logs

Prefer structured JSON logging.

## Change process

For production changes:

1. inspect
2. explain
3. edit
4. validate
5. plan
6. review
7. apply only after approval

## Coding style

Prefer reusable Terraform modules.

Avoid duplicated infrastructure definitions.

Every new resource must have:
- purpose
- tags
- dependencies
- security considerations