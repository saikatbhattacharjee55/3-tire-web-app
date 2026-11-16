output "domain_name" { value = aws_cloudfront_distribution.this.domain_name }
output "distribution_id" { value = aws_cloudfront_distribution.this.id }
output "web_url" { value = "https://${aws_cloudfront_distribution.this.domain_name}/" }
output "api_status_url" { value = "https://${aws_cloudfront_distribution.this.domain_name}/api/status" }
