# Terraform infrastructure plan

This folder builds the AWS infrastructure one reusable module at a time. The first implementation step is the VPC module. Terraform configuration and plans are local review artifacts; no AWS resources are created until a separate `terraform apply` is approved.

## Delivery steps

1. **VPC module (current):** VPC, two or three AZs, public subnets for NAT, private application subnets, isolated database subnets, route tables, internet gateway, and a cost-conscious single NAT Gateway by default.
2. **Security groups (current):** CloudFront-only HTTPS to internal load balancers, load-balancer-only ingress to each ECS service, and API-only PostgreSQL access to RDS.
3. **IAM:** ECS task execution and task roles with least-privilege policies.
4. **ECR:** separate image repositories for frontend and API.
5. **RDS:** private subnet group, database instance, encryption, backups, and secret handling.
6. **Load balancing:** internal ALB and frontend/API target groups and listener routing, aligned with the project networking guidance.
7. **ECS:** Fargate cluster and separate frontend and API task definitions/services, logs, health checks, and scaling.
8. **Edge and operations:** CloudFront/WAF, DNS if needed, alarms, and dashboards.
9. **Environment and state:** review dev inputs, remote state, and deployment workflow before use beyond local development.

Each step will be reviewed and validated before moving to the next module. Before any cloud deployment, review the plan and expected costs, then explicitly approve the apply.

## Current VPC defaults

- Region: `us-east-1` (inherited from the reference project; change before deployment if needed).
- Environment: `dev`.
- VPC: `10.0.0.0/16`.
- Availability zones: two, selected dynamically from the chosen region.
- Subnets: one public, one private application, and one isolated database subnet per AZ.
- NAT: one shared NAT Gateway by default to keep development cost lower. It is a single-AZ egress path; set `nat_gateway_per_az = true` for one gateway per AZ and higher availability, with higher cost.
- Load balancers and ECS tasks are intended to be private per the reference project guidance; the public subnets support the internet gateway and NAT only.

## Review commands

From this folder:

```powershell
terraform init
terraform fmt -recursive
terraform validate
terraform plan
```

`terraform plan` previews intended changes and does not create them. Do not run `terraform apply` until the plan has been reviewed and approved. Do not commit real credentials or `.tfvars` containing secrets.
