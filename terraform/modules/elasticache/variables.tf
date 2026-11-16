variable "project_name" {
  type = string
}
variable "environment_name" {
  type = string
}
variable "node_type" {
  type    = string
  default = "cache.t4g.micro"
}
variable "database_subnet_ids" {
  type = map(string)
}
variable "cache_security_group_id" {
  type = string
}
variable "tags" {
  type    = map(string)
  default = {}
}
