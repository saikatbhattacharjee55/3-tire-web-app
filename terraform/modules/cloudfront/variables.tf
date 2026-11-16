variable "project_name" {
  type = string
}
variable "environment_name" {
  type = string
}
variable "web_alb_arn" {
  type = string
}
variable "web_alb_dns_name" {
  type = string
}
variable "api_alb_arn" {
  type = string
}
variable "api_alb_dns_name" {
  type = string
}
variable "tags" {
  type    = map(string)
  default = {}
}
