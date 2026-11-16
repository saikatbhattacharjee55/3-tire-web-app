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

