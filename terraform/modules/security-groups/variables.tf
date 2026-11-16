variable "name" {
  description = "Short project name used in security group names."
  type        = string
}

variable "environment_name" {
  description = "Environment name used in security group names and tags."
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where the security groups are created."
  type        = string
}

variable "web_port" {
  description = "Port on which the web ECS tasks listen."
  type        = number
  default     = 3000
}

variable "api_port" {
  description = "Port on which the API ECS tasks listen."
  type        = number
  default     = 3000
}

variable "database_port" {
  description = "PostgreSQL port for RDS."
  type        = number
  default     = 5432
}

variable "tags" {
  description = "Additional tags applied to all security groups."
  type        = map(string)
  default     = {}
}

variable "alb_ingress_port" {
  description = "HTTP port used between CloudFront VPC origins and the internal ALBs."
  type        = number
  default     = 80
}
