data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  availability_zones = slice(data.aws_availability_zones.available.names, 0, var.availability_zone_count)
  az_index           = { for index, az in local.availability_zones : az => index }
  nat_azs            = var.nat_gateway_per_az ? local.availability_zones : [local.availability_zones[0]]
}
