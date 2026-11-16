output "web_alb_arn" { value = aws_lb.web.arn }
output "web_alb_dns_name" { value = aws_lb.web.dns_name }
output "web_target_group_arn" { value = aws_lb_target_group.web.arn }
output "api_alb_arn" { value = aws_lb.api.arn }
output "api_alb_dns_name" { value = aws_lb.api.dns_name }
output "api_target_group_arn" { value = aws_lb_target_group.api.arn }
