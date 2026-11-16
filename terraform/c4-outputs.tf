output "vpc_id" {
  description = "ID of the application VPC."
  value       = module.vpc.vpc_id
}

output "vpc_cidr" {
  description = "IPv4 CIDR block of the application VPC."
  value       = module.vpc.vpc_cidr
}

output "availability_zones" {
  description = "Availability zones selected for the VPC."
  value       = module.vpc.availability_zones
}

output "public_subnet_ids" {
  description = "Public subnet IDs used for internet gateways and NAT gateways."
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private application subnet IDs for ECS services and load balancers."
  value       = module.vpc.application_subnet_ids
}

output "database_subnet_ids" {
  description = "Isolated database subnet IDs for RDS."
  value       = module.vpc.database_subnet_ids
}

output "nat_gateway_ids" {
  description = "NAT Gateway IDs. One shared gateway by default, or one per AZ when enabled."
  value       = module.vpc.nat_gateway_ids
}


output "web_alb_security_group_id" {
  description = "Security group ID for the internal web load balancer."
  value       = module.security_groups.web_alb_security_group_id
}

output "api_alb_security_group_id" {
  description = "Security group ID for the internal API load balancer."
  value       = module.security_groups.api_alb_security_group_id
}

output "web_ecs_security_group_id" {
  description = "Security group ID for the web ECS tasks."
  value       = module.security_groups.web_ecs_security_group_id
}

output "api_ecs_security_group_id" {
  description = "Security group ID for the API ECS tasks."
  value       = module.security_groups.api_ecs_security_group_id
}

output "rds_security_group_id" {
  description = "Security group ID for PostgreSQL RDS."
  value       = module.security_groups.rds_security_group_id
}
