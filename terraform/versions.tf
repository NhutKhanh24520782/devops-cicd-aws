terraform {
  required_version = ">= 1.4.0"

  backend "s3" {
    bucket         = "devops-project-dev-tfstate-khanh" # output: state_bucket_name
    key            = "main/terraform.tfstate"
    region         = "ap-southeast-1"
    dynamodb_table = "devops-project-dev-tflock" # output: lock_table_name
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.52"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}
