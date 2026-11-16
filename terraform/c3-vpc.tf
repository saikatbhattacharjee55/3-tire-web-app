module "vpc" {
  source = "./modules/vpc"

  name                    = var.project_name
  environment_name        = var.environment_name
  vpc_cidr                = var.vpc_cidr
  availability_zone_count = var.availability_zone_count
  subnet_newbits          = var.subnet_newbits
  nat_gateway_per_az      = var.nat_gateway_per_az
  tags                    = var.tags
}
