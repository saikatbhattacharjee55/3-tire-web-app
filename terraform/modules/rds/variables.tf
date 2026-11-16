variable "project_name" {
  type = string
}
variable "environment_name" {
  type = string
}
variable "engine_version" {
  type    = string
  default = "16.15"
}
variable "instance_class" {
  type    = string
  default = "db.t4g.micro"
}
variable "db_name" {
  type    = string
  default = "devops_api"
}
variable "db_username" {
  type    = string
  default = "appdbowner"
}
variable "database_subnet_ids" {
  type = map(string)
}
variable "rds_security_group_id" {
  type = string
}
variable "tags" {
  type    = map(string)
  default = {}
}
