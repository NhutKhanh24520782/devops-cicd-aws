variable "project_name" {
  type        = string
  description = "Project name — used as prefix for all resource names"
}

variable "environment" {
  type        = string
  description = "Deployment environment (e.g. dev, staging, prod)"
}

variable "region" {
  type        = string
  description = "AWS region to deploy bootstrap resources into"
}
