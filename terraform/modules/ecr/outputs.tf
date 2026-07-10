output "frontend_repository_url" {

  value = module.frontend_ecr.repository_url

}

output "backend_repository_url" {

  value = module.backend_ecr.repository_url

}

output "frontend_repository_arn" {

  value = module.frontend_ecr.repository_arn

}

output "backend_repository_arn" {

  value = module.backend_ecr.repository_arn

}