resource "aws_security_group" "web_alb" {
  name                   = "${var.name}-${var.environment_name}-web-alb-sg"
  description            = "HTTPS from CloudFront origin-facing servers; egress only to web ECS tasks."
  vpc_id                 = var.vpc_id
  revoke_rules_on_delete = true

  tags = merge(var.tags, {
    Name        = "${var.name}-${var.environment_name}-web-alb-sg"
    Environment = var.environment_name
    Tier        = "load-balancer"
  })
}

resource "aws_security_group" "api_alb" {
  name                   = "${var.name}-${var.environment_name}-api-alb-sg"
  description            = "HTTPS from CloudFront origin-facing servers; egress only to API ECS tasks."
  vpc_id                 = var.vpc_id
  revoke_rules_on_delete = true

  tags = merge(var.tags, {
    Name        = "${var.name}-${var.environment_name}-api-alb-sg"
    Environment = var.environment_name
    Tier        = "load-balancer"
  })
}

resource "aws_security_group" "web_ecs" {
  name                   = "${var.name}-${var.environment_name}-web-ecs-sg"
  description            = "Web ECS tasks accept traffic only from the web load balancer."
  vpc_id                 = var.vpc_id
  revoke_rules_on_delete = true

  tags = merge(var.tags, {
    Name        = "${var.name}-${var.environment_name}-web-ecs-sg"
    Environment = var.environment_name
    Tier        = "application"
  })
}

resource "aws_security_group" "api_ecs" {
  name                   = "${var.name}-${var.environment_name}-api-ecs-sg"
  description            = "API ECS tasks accept traffic only from the API load balancer."
  vpc_id                 = var.vpc_id
  revoke_rules_on_delete = true

  tags = merge(var.tags, {
    Name        = "${var.name}-${var.environment_name}-api-ecs-sg"
    Environment = var.environment_name
    Tier        = "application"
  })
}

resource "aws_security_group" "rds" {
  name                   = "${var.name}-${var.environment_name}-rds-sg"
  description            = "RDS accepts PostgreSQL connections only from API ECS tasks."
  vpc_id                 = var.vpc_id
  revoke_rules_on_delete = true

  tags = merge(var.tags, {
    Name        = "${var.name}-${var.environment_name}-rds-sg"
    Environment = var.environment_name
    Tier        = "database"
  })
}

resource "aws_vpc_security_group_ingress_rule" "web_alb_from_cloudfront" {
  security_group_id = aws_security_group.web_alb.id
  prefix_list_id    = data.aws_ec2_managed_prefix_list.cloudfront_origin_facing.id
  from_port         = var.alb_ingress_port
  to_port           = var.alb_ingress_port
  ip_protocol       = "tcp"
  description       = "HTTP from CloudFront origin-facing servers to internal ALB listeners."
}

resource "aws_vpc_security_group_ingress_rule" "api_alb_from_cloudfront" {
  security_group_id = aws_security_group.api_alb.id
  prefix_list_id    = data.aws_ec2_managed_prefix_list.cloudfront_origin_facing.id
  from_port         = var.alb_ingress_port
  to_port           = var.alb_ingress_port
  ip_protocol       = "tcp"
  description       = "HTTP from CloudFront origin-facing servers to internal ALB listeners."
}

resource "aws_vpc_security_group_ingress_rule" "web_ecs_from_alb" {
  security_group_id            = aws_security_group.web_ecs.id
  referenced_security_group_id = aws_security_group.web_alb.id
  from_port                    = var.web_port
  to_port                      = var.web_port
  ip_protocol                  = "tcp"
  description                  = "Web application traffic from the web load balancer."
}

resource "aws_vpc_security_group_ingress_rule" "api_ecs_from_alb" {
  security_group_id            = aws_security_group.api_ecs.id
  referenced_security_group_id = aws_security_group.api_alb.id
  from_port                    = var.api_port
  to_port                      = var.api_port
  ip_protocol                  = "tcp"
  description                  = "API traffic from the API load balancer."
}

resource "aws_vpc_security_group_ingress_rule" "rds_from_api" {
  security_group_id            = aws_security_group.rds.id
  referenced_security_group_id = aws_security_group.api_ecs.id
  from_port                    = var.database_port
  to_port                      = var.database_port
  ip_protocol                  = "tcp"
  description                  = "PostgreSQL from API ECS tasks only."
}

resource "aws_vpc_security_group_egress_rule" "web_alb_to_web_ecs" {
  security_group_id            = aws_security_group.web_alb.id
  referenced_security_group_id = aws_security_group.web_ecs.id
  from_port                    = var.web_port
  to_port                      = var.web_port
  ip_protocol                  = "tcp"
  description                  = "Forward web traffic to web ECS tasks."
}

resource "aws_vpc_security_group_egress_rule" "api_alb_to_api_ecs" {
  security_group_id            = aws_security_group.api_alb.id
  referenced_security_group_id = aws_security_group.api_ecs.id
  from_port                    = var.api_port
  to_port                      = var.api_port
  ip_protocol                  = "tcp"
  description                  = "Forward API traffic to API ECS tasks."
}

resource "aws_vpc_security_group_egress_rule" "web_ecs_https" {
  security_group_id = aws_security_group.web_ecs.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  description       = "HTTPS egress through the private subnet NAT for AWS APIs and external services."
}

resource "aws_vpc_security_group_egress_rule" "api_ecs_https" {
  security_group_id = aws_security_group.api_ecs.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  description       = "HTTPS egress through the private subnet NAT for AWS APIs and external services."
}

resource "aws_vpc_security_group_egress_rule" "api_ecs_to_rds" {
  security_group_id            = aws_security_group.api_ecs.id
  referenced_security_group_id = aws_security_group.rds.id
  from_port                    = var.database_port
  to_port                      = var.database_port
  ip_protocol                  = "tcp"
  description                  = "PostgreSQL egress to the RDS security group."
}

resource "aws_security_group" "cache" {
  name                   = "${var.name}-${var.environment_name}-cache-sg"
  description            = "Redis access only from the web and API ECS task security groups."
  vpc_id                 = var.vpc_id
  revoke_rules_on_delete = true
  tags                   = merge(var.tags, { Name = "${var.name}-${var.environment_name}-cache-sg", Environment = var.environment_name, Tier = "cache" })
}
resource "aws_vpc_security_group_ingress_rule" "cache_from_web" {
  security_group_id            = aws_security_group.cache.id
  referenced_security_group_id = aws_security_group.web_ecs.id
  from_port                    = 6379
  to_port                      = 6379
  ip_protocol                  = "tcp"
  description                  = "Redis TLS from web ECS tasks."
}
resource "aws_vpc_security_group_ingress_rule" "cache_from_api" {
  security_group_id            = aws_security_group.cache.id
  referenced_security_group_id = aws_security_group.api_ecs.id
  from_port                    = 6379
  to_port                      = 6379
  ip_protocol                  = "tcp"
  description                  = "Redis TLS from API ECS tasks."
}
resource "aws_vpc_security_group_egress_rule" "web_ecs_to_api_alb" {
  security_group_id            = aws_security_group.web_ecs.id
  referenced_security_group_id = aws_security_group.api_alb.id
  from_port                    = var.alb_ingress_port
  to_port                      = var.alb_ingress_port
  ip_protocol                  = "tcp"
  description                  = "Web server-side API requests to the internal API load balancer."
}
resource "aws_vpc_security_group_ingress_rule" "api_alb_from_web_ecs" {
  security_group_id            = aws_security_group.api_alb.id
  referenced_security_group_id = aws_security_group.web_ecs.id
  from_port                    = var.alb_ingress_port
  to_port                      = var.alb_ingress_port
  ip_protocol                  = "tcp"
  description                  = "Web server-side requests to the API load balancer."
}
resource "aws_vpc_security_group_egress_rule" "web_ecs_to_cache" {
  security_group_id            = aws_security_group.web_ecs.id
  referenced_security_group_id = aws_security_group.cache.id
  from_port                    = 6379
  to_port                      = 6379
  ip_protocol                  = "tcp"
  description                  = "Redis TLS access from web tasks."
}
resource "aws_vpc_security_group_egress_rule" "api_ecs_to_cache" {
  security_group_id            = aws_security_group.api_ecs.id
  referenced_security_group_id = aws_security_group.cache.id
  from_port                    = 6379
  to_port                      = 6379
  ip_protocol                  = "tcp"
  description                  = "Redis TLS access from API tasks."
}
