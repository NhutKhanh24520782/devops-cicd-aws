# Frontend Repository
module "frontend_ecr" {

  source = "terraform-aws-modules/ecr/aws"

  repository_name = "${var.project_name}-${var.environment}-frontend"

  repository_type = "private"

  repository_image_scan_on_push = true

  repository_force_delete = true

  create_lifecycle_policy = false

  tags = {
    Project     = var.project_name
    Environment = var.environment
    Terraform   = "true"
  }
}

# Backend Repository
module "backend_ecr" {

  source = "terraform-aws-modules/ecr/aws"

  repository_name = "${var.project_name}-${var.environment}-backend"

  repository_type = "private"

  repository_image_scan_on_push = true

  repository_force_delete = true

  create_lifecycle_policy = false

  tags = {

    Project     = var.project_name
    Environment = var.environment
    Terraform   = "true"

  }

}
