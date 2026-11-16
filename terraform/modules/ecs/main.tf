resource "aws_ecs_cluster" "this" {
  name = "${var.project_name}-${var.environment_name}"
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
  tags = merge(var.tags, { Name = "${var.project_name}-${var.environment_name}-ecs", Tier = "compute" })
}
resource "aws_cloudwatch_log_group" "web" {
  name              = "/ecs/${var.project_name}/${var.environment_name}/web"
  retention_in_days = 14
  tags              = merge(var.tags, { Name = "/ecs/${var.project_name}/${var.environment_name}/web", Tier = "logging" })
}
resource "aws_cloudwatch_log_group" "api" {
  name              = "/ecs/${var.project_name}/${var.environment_name}/api"
  retention_in_days = 14
  tags              = merge(var.tags, { Name = "/ecs/${var.project_name}/${var.environment_name}/api", Tier = "logging" })
}
resource "aws_ecs_task_definition" "web" {
  family                   = "${var.project_name}-${var.environment_name}-web"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.task_role_arn
  container_definitions = jsonencode([{
    name         = "web"
    image        = "${var.web_image_repository}:${var.image_tag}"
    essential    = true
    portMappings = [{ containerPort = 3000, protocol = "tcp" }]
    environment = [
      { name = "API_HOST", value = "http://${var.api_alb_dns_name}" },
      { name = "NODE_ENV", value = "production" }
    ]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = aws_cloudwatch_log_group.web.name
        awslogs-region        = var.aws_region
        awslogs-stream-prefix = "web"
      }
    }
  }])
  tags = merge(var.tags, { Name = "${var.project_name}-${var.environment_name}-web-task", Tier = "web" })
}
resource "aws_ecs_task_definition" "api" {
  family                   = "${var.project_name}-${var.environment_name}-api"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.task_role_arn
  container_definitions = jsonencode([{
    name         = "api"
    image        = "${var.api_image_repository}:${var.image_tag}"
    essential    = true
    portMappings = [{ containerPort = 3000, protocol = "tcp" }]
    environment = [
      { name = "NODE_ENV", value = "production" },
      { name = "DBHOST", value = var.db_endpoint },
      { name = "DBPORT", value = tostring(var.db_port) },
      { name = "DB", value = var.db_name },
      { name = "DBUSER", value = var.db_username },
      { name = "DBSSL", value = "true" }
    ]
    secrets = [{ name = "DBPASS", valueFrom = "${var.db_secret_arn}:password::" }]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = aws_cloudwatch_log_group.api.name
        awslogs-region        = var.aws_region
        awslogs-stream-prefix = "api"
      }
    }
  }])
  tags = merge(var.tags, { Name = "${var.project_name}-${var.environment_name}-api-task", Tier = "api" })
}
resource "aws_ecs_service" "web" {
  name                               = "${var.project_name}-${var.environment_name}-web"
  cluster                            = aws_ecs_cluster.this.id
  task_definition                    = aws_ecs_task_definition.web.arn
  desired_count                      = var.deploy_services ? var.desired_count : 0
  launch_type                        = "FARGATE"
  platform_version                   = "LATEST"
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200
  health_check_grace_period_seconds  = 90
  network_configuration {
    subnets          = values(var.private_subnet_ids)
    security_groups  = [var.web_ecs_security_group_id]
    assign_public_ip = false
  }
  load_balancer {
    target_group_arn = var.web_target_group_arn
    container_name   = "web"
    container_port   = 3000
  }
  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }
  tags = merge(var.tags, { Name = "${var.project_name}-${var.environment_name}-web-service", Tier = "web" })
}
resource "aws_ecs_service" "api" {
  name                               = "${var.project_name}-${var.environment_name}-api"
  cluster                            = aws_ecs_cluster.this.id
  task_definition                    = aws_ecs_task_definition.api.arn
  desired_count                      = var.deploy_services ? var.desired_count : 0
  launch_type                        = "FARGATE"
  platform_version                   = "LATEST"
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200
  health_check_grace_period_seconds  = 90
  network_configuration {
    subnets          = values(var.private_subnet_ids)
    security_groups  = [var.api_ecs_security_group_id]
    assign_public_ip = false
  }
  load_balancer {
    target_group_arn = var.api_target_group_arn
    container_name   = "api"
    container_port   = 3000
  }
  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }
  tags = merge(var.tags, { Name = "${var.project_name}-${var.environment_name}-api-service", Tier = "api" })
}
