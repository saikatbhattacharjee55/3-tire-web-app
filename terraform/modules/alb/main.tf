resource "aws_lb" "web" {
  name               = "${var.project_name}-${var.environment_name}-web"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [var.web_alb_security_group_id]
  subnets            = values(var.private_subnet_ids)
  tags               = merge(var.tags, { Name = "${var.project_name}-${var.environment_name}-web-alb", Tier = "web" })
}
resource "aws_lb_target_group" "web" {
  name        = "${var.environment_name}-web-tg"
  port        = 3000
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id
  health_check {
    enabled             = true
    path                = "/health"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }
  deregistration_delay = 30
  tags                 = merge(var.tags, { Name = "${var.environment_name}-web-tg", Tier = "web" })
}
resource "aws_lb_listener" "web" {
  load_balancer_arn = aws_lb.web.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}
resource "aws_lb" "api" {
  name               = "${var.project_name}-${var.environment_name}-api"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [var.api_alb_security_group_id]
  subnets            = values(var.private_subnet_ids)
  tags               = merge(var.tags, { Name = "${var.project_name}-${var.environment_name}-api-alb", Tier = "api" })
}
resource "aws_lb_target_group" "api" {
  name        = "${var.environment_name}-api-tg"
  port        = 3000
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id
  health_check {
    enabled             = true
    path                = "/api/status"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }
  deregistration_delay = 30
  tags                 = merge(var.tags, { Name = "${var.environment_name}-api-tg", Tier = "api" })
}
resource "aws_lb_listener" "api" {
  load_balancer_arn = aws_lb.api.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.api.arn
  }
}
