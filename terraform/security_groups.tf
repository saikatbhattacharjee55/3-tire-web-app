module "security_groups" {
  source = "./modules/security-groups"

  name             = var.project_name
  environment_name = var.environment_name
  vpc_id           = module.vpc.vpc_id
  tags             = var.tags
}
