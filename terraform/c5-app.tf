module "ecr" {
  source           = "./modules/ecr"
  project_name     = var.project_name
  environment_name = var.environment_name
  tags             = var.tags
}
module "rds" {
  source                = "./modules/rds"
  project_name          = var.project_name
  environment_name      = var.environment_name
  database_subnet_ids   = module.vpc.database_subnet_ids
  rds_security_group_id = module.security_groups.rds_security_group_id
  instance_class        = var.rds_instance_class
  tags                  = var.tags
}
module "iam" {
  source           = "./modules/iam"
  project_name     = var.project_name
  environment_name = var.environment_name
  aws_region       = var.aws_region
  rds_secret_arn   = module.rds.secret_arn
  tags             = var.tags
}
module "elasticache" {
  source                  = "./modules/elasticache"
  project_name            = var.project_name
  environment_name        = var.environment_name
  database_subnet_ids     = module.vpc.database_subnet_ids
  cache_security_group_id = module.security_groups.cache_security_group_id
  node_type               = var.elasticache_node_type
  tags                    = var.tags
}
module "alb" {
  source                    = "./modules/alb"
  project_name              = var.project_name
  environment_name          = var.environment_name
  vpc_id                    = module.vpc.vpc_id
  private_subnet_ids        = module.vpc.application_subnet_ids
  web_alb_security_group_id = module.security_groups.web_alb_security_group_id
  api_alb_security_group_id = module.security_groups.api_alb_security_group_id
  tags                      = var.tags
}
module "cloudfront" {
  source           = "./modules/cloudfront"
  project_name     = var.project_name
  environment_name = var.environment_name
  web_alb_arn      = module.alb.web_alb_arn
  web_alb_dns_name = module.alb.web_alb_dns_name
  api_alb_arn      = module.alb.api_alb_arn
  api_alb_dns_name = module.alb.api_alb_dns_name
  tags             = var.tags
}
module "ecs" {
  source                    = "./modules/ecs"
  project_name              = var.project_name
  environment_name          = var.environment_name
  aws_region                = var.aws_region
  image_tag                 = var.image_tag
  web_image_repository      = module.ecr.web_repository_url
  api_image_repository      = module.ecr.api_repository_url
  execution_role_arn        = module.iam.execution_role_arn
  task_role_arn             = module.iam.task_role_arn
  private_subnet_ids        = module.vpc.application_subnet_ids
  web_ecs_security_group_id = module.security_groups.web_ecs_security_group_id
  api_ecs_security_group_id = module.security_groups.api_ecs_security_group_id
  web_target_group_arn      = module.alb.web_target_group_arn
  api_target_group_arn      = module.alb.api_target_group_arn
  api_alb_dns_name          = module.alb.api_alb_dns_name
  db_endpoint               = module.rds.endpoint
  db_port                   = module.rds.port
  db_name                   = module.rds.db_name
  db_username               = module.rds.username
  db_secret_arn             = module.rds.secret_arn
  deploy_services           = var.deploy_services
  desired_count             = var.ecs_desired_count
  tags                      = var.tags
  depends_on                = [module.alb, module.rds, module.iam]
}
