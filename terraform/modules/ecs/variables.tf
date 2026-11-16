variable "project_name" { type = string }
variable "environment_name" { type = string }
variable "aws_region" { type = string }
variable "image_tag" { type = string }
variable "web_image_repository" { type = string }
variable "api_image_repository" { type = string }
variable "execution_role_arn" { type = string }
variable "task_role_arn" { type = string }
variable "private_subnet_ids" { type = map(string) }
variable "web_ecs_security_group_id" { type = string }
variable "api_ecs_security_group_id" { type = string }
variable "web_target_group_arn" { type = string }
variable "api_target_group_arn" { type = string }
variable "api_alb_dns_name" { type = string }
variable "db_endpoint" { type = string }
variable "db_port" { type = number }
variable "db_name" { type = string }
variable "db_username" { type = string }
variable "db_secret_arn" { type = string }
variable "deploy_services" { type = bool }
variable "desired_count" {
  type    = number
  default = 1
}
variable "tags" {
  type    = map(string)
  default = {}
}
