variable "project_name" {
  type = string
}
variable "environment_name" {
  type = string
}
variable "aws_region" {
  type = string
}
variable "rds_secret_arn" {
  type = string
}
variable "tags" {
  type    = map(string)
  default = {}
}
