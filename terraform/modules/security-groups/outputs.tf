output "web_alb_security_group_id" {
  description = "Security group ID for the internal web load balancer."
  value       = aws_security_group.web_alb.id
}

output "api_alb_security_group_id" {
  description = "Security group ID for the internal API load balancer."
  value       = aws_security_group.api_alb.id
}

output "web_ecs_security_group_id" {
  description = "Security group ID for the web ECS tasks."
  value       = aws_security_group.web_ecs.id
}

output "api_ecs_security_group_id" {
  description = "Security group ID for the API ECS tasks."
  value       = aws_security_group.api_ecs.id
}

output "rds_security_group_id" {
  description = "Security group ID for the RDS database."
  value       = aws_security_group.rds.id
}

output "cache_security_group_id" {
  description = "Security group ID for the private ElastiCache cluster."
  value       = aws_security_group.cache.id
}
