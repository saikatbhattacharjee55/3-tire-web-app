output "endpoint" { value = aws_db_instance.postgres.address }
output "port" { value = aws_db_instance.postgres.port }
output "db_name" { value = aws_db_instance.postgres.db_name }
output "username" { value = aws_db_instance.postgres.username }
output "secret_arn" { value = aws_db_instance.postgres.master_user_secret[0].secret_arn }
