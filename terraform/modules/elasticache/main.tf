resource "aws_elasticache_subnet_group" "this" {
  name       = "${var.project_name}-${var.environment_name}-cache-subnets"
  subnet_ids = values(var.database_subnet_ids)
  tags       = merge(var.tags, { Name = "${var.project_name}-${var.environment_name}-cache-subnets", Tier = "cache", managed_by = "aws-skills", skill = "elasticache", skill_version = "1.0.0", created_by = "elasticache-skill", generation_model = "gpt-6-codex" })
}
resource "random_password" "auth_token" {
  length           = 48
  special          = true
  override_special = "!#$%&*()-_=+[]{}:?"
}
resource "aws_secretsmanager_secret" "auth_token" {
  name                    = "${var.project_name}/${var.environment_name}/elasticache/auth-token"
  description             = "Redis TLS AUTH token; app does not use Redis yet."
  recovery_window_in_days = 7
  tags                    = merge(var.tags, { Name = "${var.project_name}-${var.environment_name}-redis-auth", Tier = "cache", managed_by = "aws-skills", skill = "elasticache", skill_version = "1.0.0", created_by = "elasticache-skill", generation_model = "gpt-6-codex" })
}
resource "aws_secretsmanager_secret_version" "auth_token" {
  secret_id     = aws_secretsmanager_secret.auth_token.id
  secret_string = random_password.auth_token.result
}
resource "aws_elasticache_replication_group" "this" {
  replication_group_id       = "${var.environment_name}-node-cache"
  description                = "Private Redis OSS cache for ${var.project_name} ${var.environment_name}"
  engine                     = "redis"
  engine_version             = "7.1"
  node_type                  = var.node_type
  num_cache_clusters         = 2
  automatic_failover_enabled = true
  multi_az_enabled           = true
  port                       = 6379
  subnet_group_name          = aws_elasticache_subnet_group.this.name
  security_group_ids         = [var.cache_security_group_id]
  at_rest_encryption_enabled = true
  transit_encryption_enabled = true
  auth_token                 = random_password.auth_token.result
  auto_minor_version_upgrade = true
  snapshot_retention_limit   = 3
  snapshot_window            = "02:00-03:00"
  maintenance_window         = "sun:03:00-sun:04:00"
  apply_immediately          = true
  tags                       = merge(var.tags, { Name = "${var.project_name}-${var.environment_name}-redis", Tier = "cache", managed_by = "aws-skills", skill = "elasticache", skill_version = "1.0.0", created_by = "elasticache-skill", generation_model = "gpt-6-codex" })
  depends_on                 = [aws_secretsmanager_secret_version.auth_token]
}
