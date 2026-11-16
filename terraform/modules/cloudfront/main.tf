resource "aws_cloudfront_vpc_origin" "web" {
  vpc_origin_endpoint_config {
    name                   = "${var.environment_name}-web-vpc-origin"
    arn                    = var.web_alb_arn
    http_port              = 80
    https_port             = 443
    origin_protocol_policy = "http-only"
    origin_ssl_protocols {
      items    = ["TLSv1.2"]
      quantity = 1
    }
  }
  tags = merge(var.tags, { Name = "${var.environment_name}-web-vpc-origin", Tier = "cdn" })
}
resource "aws_cloudfront_vpc_origin" "api" {
  vpc_origin_endpoint_config {
    name                   = "${var.environment_name}-api-vpc-origin"
    arn                    = var.api_alb_arn
    http_port              = 80
    https_port             = 443
    origin_protocol_policy = "http-only"
    origin_ssl_protocols {
      items    = ["TLSv1.2"]
      quantity = 1
    }
  }
  tags = merge(var.tags, { Name = "${var.environment_name}-api-vpc-origin", Tier = "cdn" })
}
resource "aws_cloudfront_distribution" "this" {
  enabled         = true
  is_ipv6_enabled = true
  price_class     = "PriceClass_100"
  comment         = "${var.project_name} ${var.environment_name} web and API"
  origin {
    domain_name = var.web_alb_dns_name
    origin_id   = "${var.environment_name}-web-origin"
    vpc_origin_config { vpc_origin_id = aws_cloudfront_vpc_origin.web.id }
  }
  origin {
    domain_name = var.api_alb_dns_name
    origin_id   = "${var.environment_name}-api-origin"
    vpc_origin_config { vpc_origin_id = aws_cloudfront_vpc_origin.api.id }
  }
  default_cache_behavior {
    target_origin_id         = "${var.environment_name}-web-origin"
    viewer_protocol_policy   = "redirect-to-https"
    allowed_methods          = ["GET", "HEAD", "OPTIONS"]
    cached_methods           = ["GET", "HEAD"]
    compress                 = true
    cache_policy_id          = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad"
    origin_request_policy_id = "b689b0a8-53d0-40ab-baf2-68738e2966ac"
  }
  ordered_cache_behavior {
    path_pattern             = "/api/*"
    target_origin_id         = "${var.environment_name}-api-origin"
    viewer_protocol_policy   = "redirect-to-https"
    allowed_methods          = ["GET", "HEAD", "OPTIONS"]
    cached_methods           = ["GET", "HEAD"]
    compress                 = true
    cache_policy_id          = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad"
    origin_request_policy_id = "b689b0a8-53d0-40ab-baf2-68738e2966ac"
  }
  restrictions {
    geo_restriction { restriction_type = "none" }
  }
  viewer_certificate { cloudfront_default_certificate = true }
  tags = merge(var.tags, { Name = "${var.project_name}-${var.environment_name}-cloudfront", Tier = "cdn" })
}
