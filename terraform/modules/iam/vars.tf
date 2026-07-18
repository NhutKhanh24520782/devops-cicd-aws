variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "oidc_provider_arn" {
  description = "Full ARN of the EKS OIDC provider (e.g. arn:aws:iam::123456789:oidc-provider/oidc.eks.ap-southeast-1.amazonaws.com/id/XXXX)"
  type        = string
}

variable "oidc_provider" {
  description = "OIDC provider URL without https:// (e.g. oidc.eks.ap-southeast-1.amazonaws.com/id/XXXX)"
  type        = string
}
