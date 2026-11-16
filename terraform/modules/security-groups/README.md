# Security groups module

Creates separate security groups for the web load balancer, API load balancer, web ECS tasks, API ECS tasks, and PostgreSQL RDS.

## Traffic policy

- Both load balancers accept HTTPS on port 443 from the AWS-managed CloudFront origin-facing prefix list. They do not accept direct internet ingress.
- Each ECS task security group accepts its application port (3000 by default) only from its matching load balancer security group.
- ECS tasks can make outbound HTTPS requests through the private-subnet NAT gateway.
- The API tasks can reach PostgreSQL on port 5432. The RDS group accepts that port only from the API ECS group and has no outbound rules.
- Load balancer egress is limited to the matching ECS security group and application port.

The CloudFront prefix list is broad across CloudFront origin-facing addresses. After the CloudFront VPC origins exist, the origin security groups can be further restricted to the AWS service-managed `CloudFront-VPCOrigins-Service-SG` for distribution-specific access.

## Inputs

| Name | Description | Default |
| --- | --- | --- |
| `name` | Project name | required |
| `environment_name` | Environment name | required |
| `vpc_id` | VPC ID | required |
| `web_port` | Web container port | `3000` |
| `api_port` | API container port | `3000` |
| `database_port` | PostgreSQL port | `5432` |
| `tags` | Additional tags | `{}` |

## Outputs

IDs for the web/API load balancer groups, web/API ECS groups, and RDS group.
