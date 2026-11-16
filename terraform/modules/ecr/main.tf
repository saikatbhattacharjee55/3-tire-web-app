resource "aws_ecr_repository" "web" {
  name                 = "${var.project_name}-${var.environment_name}-web"
  image_tag_mutability = "IMMUTABLE"
  image_scanning_configuration { scan_on_push = true }
  encryption_configuration { encryption_type = "AES256" }
  tags = merge(var.tags, { Name = "${var.project_name}-${var.environment_name}-web-ecr", Tier = "web" })
}
resource "aws_ecr_repository" "api" {
  name                 = "${var.project_name}-${var.environment_name}-api"
  image_tag_mutability = "IMMUTABLE"
  image_scanning_configuration { scan_on_push = true }
  encryption_configuration { encryption_type = "AES256" }
  tags = merge(var.tags, { Name = "${var.project_name}-${var.environment_name}-api-ecr", Tier = "api" })
}
resource "aws_ecr_lifecycle_policy" "web" {
  repository = aws_ecr_repository.web.name
  policy     = jsonencode({ rules = [{ rulePriority = 1, description = "Expire untagged images after 30 days", selection = { tagStatus = "untagged", countType = "sinceImagePushed", countUnit = "days", countNumber = 30 }, action = { type = "expire" } }] })
}
resource "aws_ecr_lifecycle_policy" "api" {
  repository = aws_ecr_repository.api.name
  policy     = jsonencode({ rules = [{ rulePriority = 1, description = "Expire untagged images after 30 days", selection = { tagStatus = "untagged", countType = "sinceImagePushed", countUnit = "days", countNumber = 30 }, action = { type = "expire" } }] })
}
