variable "name" {
  description = "Short project name used in resource names."
  type        = string
}

variable "environment_name" {
  description = "Environment name used in resource names and tags."
  type        = string
}

variable "vpc_cidr" {
  description = "IPv4 CIDR block for the VPC."
  type        = string

  validation {
    condition     = can(cidrnetmask(var.vpc_cidr))
    error_message = "vpc_cidr must be a valid IPv4 CIDR block."
  }
}

variable "availability_zone_count" {
  description = "Number of AZs used for subnet placement."
  type        = number

  validation {
    condition     = var.availability_zone_count >= 2 && var.availability_zone_count <= 3 && floor(var.availability_zone_count) == var.availability_zone_count
    error_message = "availability_zone_count must be the whole number 2 or 3."
  }
}

variable "subnet_newbits" {
  description = "Additional CIDR bits used to divide the VPC into subnets."
  type        = number

  validation {
    condition     = var.subnet_newbits >= 1 && var.subnet_newbits <= 8 && floor(var.subnet_newbits) == var.subnet_newbits
    error_message = "subnet_newbits must be a whole number between 1 and 8."
  }
}

variable "nat_gateway_per_az" {
  description = "Whether to create one NAT Gateway in each AZ."
  type        = bool
}

variable "tags" {
  description = "Additional tags applied to all VPC resources."
  type        = map(string)
  default     = {}
}
