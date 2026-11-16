variable "project_name" {
  type = string
}
variable "environment_name" {
  type = string
}
variable "vpc_id" {
  type = string
}
variable "private_subnet_ids" {
  type = map(string)
}
variable "web_alb_security_group_id" {
  type = string
}
variable "api_alb_security_group_id" {
  type = string
}
variable "tags" {
  type    = map(string)
  default = {}
}
