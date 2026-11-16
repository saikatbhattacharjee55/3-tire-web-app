# AWS three-tier web application

Terraform modules for deploying the current web and API containers to AWS ECS/Fargate in the existing dev VPC.

## Architecture

CloudFront provides HTTPS and sends `/api/*` to the private API ALB; all other paths go to the private web ALB. Each internal ALB forwards to its own ECS service. The API uses private PostgreSQL RDS. A private Redis OSS cluster is included to match the reference project, but the checked-in app does not currently use Redis. The existing VPC has public/NAT, private application, and isolated database subnets.

The checked-in `web` application is Express/Jade, not React. The modules deploy the current source as-is.

## Modules

- `vpc` and `security-groups`: network foundation and tier-specific access rules.
- `ecr`: separate immutable, scan-on-push repositories for web and API.
- `iam`: least-privilege ECS execution/task roles and database-secret read access.
- `rds`: encrypted private PostgreSQL with an RDS-managed master password.
- `elasticache`: private, TLS-enabled two-node Redis OSS 7.1 with an AUTH token in Secrets Manager.
- `alb`: separate internal web/API ALBs, target groups, and health checks.
- `ecs`: separate Fargate task definitions/services and CloudWatch log groups.
- `cloudfront`: HTTPS viewer endpoint and `/api/*` route to the API origin.

## Deployment

From this directory:

```powershell
terraform init
terraform fmt -recursive
terraform validate
terraform plan
```

The ECS services default to zero tasks while images are prepared. The current app images use immutable tag `49dd7dc`. Set `deploy_services = true` in a local ignored `terraform.auto.tfvars` file, then plan and apply to start one task for each service.

Terraform outputs `web_url` and `api_status_url`. The status endpoint is `/api/status`.

The current AWS account rejected the RDS creation request because the requested automated backup retention exceeds its Free Tier limit. Resolve the account restriction or explicitly choose a permitted development retention setting before reapplying RDS and ECS.

Do not commit `.env`, `.tfvars`, Terraform state, or plan files. The local Terraform state includes sensitive ElastiCache authentication material; protect it and migrate to encrypted remote state before team use.
