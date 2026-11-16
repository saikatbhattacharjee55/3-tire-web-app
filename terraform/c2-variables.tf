variable "aws_region" {
  description = "AWS region for this environment."
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name applied to resources as a tag."
  type        = string
  default     = "terraform-ecs-node"
}

variable "environment_name" {
  description = "Environment name used in resource names and tags."
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "IPv4 CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"

  validation {
    condition     = can(cidrnetmask(var.vpc_cidr))
    error_message = "vpc_cidr must be a valid IPv4 CIDR block."
  }
}

variable "availability_zone_count" {
  description = "Number of available AZs to use. Use at least two for resilience."
  type        = number
  default     = 2

  validation {
    condition     = var.availability_zone_count >= 2 && var.availability_zone_count <= 3 && floor(var.availability_zone_count) == var.availability_zone_count
    error_message = "availability_zone_count must be the whole number 2 or 3."
  }
}

variable "subnet_newbits" {
  description = "Additional CIDR bits for each subnet; 8 creates /24 subnets from a /16 VPC."
  type        = number
  default     = 8

  validation {
    condition     = var.subnet_newbits >= 1 && var.subnet_newbits <= 8 && floor(var.subnet_newbits) == var.subnet_newbits
    error_message = "subnet_newbits must be a whole number between 1 and 8."
  }
}

variable "nat_gateway_per_az" {
  description = "Create one NAT Gateway per AZ for higher availability. False uses one shared NAT Gateway to reduce development cost."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Additional tags applied to all resources."
  type        = map(string)
  default     = {}
}
