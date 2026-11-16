resource "aws_db_subnet_group" "this" {
  name       = "${var.project_name}-${var.environment_name}-db-subnets"
  subnet_ids = values(var.database_subnet_ids)
  tags       = merge(var.tags, { Name = "${var.project_name}-${var.environment_name}-db-subnets", Tier = "database", created_by = "rds-oss-skill", generation_model = "gpt-6-codex" })
}
resource "aws_db_parameter_group" "this" {
  name        = "${var.project_name}-${var.environment_name}-postgres16"
  family      = "postgres16"
  description = "Require TLS for PostgreSQL client connections"
  parameter {
    name         = "rds.force_ssl"
    value        = "1"
    apply_method = "pending-reboot"
  }
  tags = merge(var.tags, { Name = "${var.project_name}-${var.environment_name}-postgres16", Tier = "database", created_by = "rds-oss-skill", generation_model = "gpt-6-codex" })
}
resource "aws_db_instance" "postgres" {
  identifier                  = "${var.project_name}-${var.environment_name}-postgres"
  engine                      = "postgres"
  engine_version              = var.engine_version
  instance_class              = var.instance_class
  allocated_storage           = 20
  max_allocated_storage       = 40
  storage_type                = "gp3"
  storage_encrypted           = true
  db_name                     = var.db_name
  username                    = var.db_username
  manage_master_user_password = true
  port                        = 5432
  db_subnet_group_name        = aws_db_subnet_group.this.name
  vpc_security_group_ids      = [var.rds_security_group_id]
  parameter_group_name        = aws_db_parameter_group.this.name
  publicly_accessible         = false
  multi_az                    = false
  backup_retention_period     = 3
  auto_minor_version_upgrade  = true
  deletion_protection         = true
  skip_final_snapshot         = false
  final_snapshot_identifier   = "${var.project_name}-${var.environment_name}-postgres-final"
  copy_tags_to_snapshot       = true
  apply_immediately           = true
  tags                        = merge(var.tags, { Name = "${var.project_name}-${var.environment_name}-postgres", Tier = "database", created_by = "rds-oss-skill", generation_model = "gpt-6-codex" })
}
