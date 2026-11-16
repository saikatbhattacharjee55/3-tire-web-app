output "vpc_id" {
  description = "ID of the VPC."
  value       = aws_vpc.main.id
}

output "vpc_cidr" {
  description = "IPv4 CIDR block of the VPC."
  value       = aws_vpc.main.cidr_block
}

output "availability_zones" {
  description = "Availability zones used by this VPC."
  value       = local.availability_zones
}

output "public_subnet_ids" {
  description = "Public subnet IDs keyed by availability zone."
  value       = { for az, subnet in aws_subnet.public : az => subnet.id }
}

output "application_subnet_ids" {
  description = "Private application subnet IDs keyed by availability zone."
  value       = { for az, subnet in aws_subnet.application : az => subnet.id }
}

output "database_subnet_ids" {
  description = "Isolated database subnet IDs keyed by availability zone."
  value       = { for az, subnet in aws_subnet.database : az => subnet.id }
}

output "nat_gateway_ids" {
  description = "NAT Gateway IDs keyed by the AZ where each gateway is placed."
  value       = { for az, gateway in aws_nat_gateway.main : az => gateway.id }
}

output "nat_public_ips" {
  description = "Public IP addresses allocated to NAT Gateways, keyed by AZ."
  value       = { for az, eip in aws_eip.nat : az => eip.public_ip }
}
