module "vpc" {

  source = "./modules/vpc"

  project_name        = var.project_name
  cluster_name        = var.cluster_name
  environment         = var.environment
  cidr_block          = var.cidr_block
  availability_zones  = var.availability_zones
  public_subnets      = var.public_subnets
  private_subnets     = var.private_subnets
  intra_subnets       = var.intra_subnets

}
module "security_group" {

  source = "./modules/security-group"

  vpc_id         = module.vpc.vpc_id
  workstation_ip = var.workstation_ip

}
module "iam" {

  source = "./modules/iam"

  project_name = var.project_name
  environment  = var.environment

}
module "endpoint" {
  source = "./modules/endpoint"

  project_name                 = var.project_name
  environment                  = var.environment
  region                       = var.region
  vpc_id                       = module.vpc.vpc_id
  intra_subnets                = module.vpc.intra_subnets
  private_route_table_ids      = module.vpc.private_route_table_ids
  endpoint_security_group_id   = module.security_group.endpoint_security_group_id
}

module "bastion" {
  source = "./modules/bastion"

  project_name = var.project_name
  environment  = var.environment
  sg_id        = module.security_group.bastion_security_group_id
  key_name     = var.key_name
  subnet_id    = module.vpc.public_subnets[0]
  ami          = var.bastion_ami
  instance_type = var.bastion_instance_type
}

module "eks" {
  source = "./modules/eks"

  project_name       = var.project_name
  environment        = var.environment
  kubernetes_version = var.kubernetes_version
  vpc_id             = module.vpc.vpc_id
  private_subnets    = module.vpc.private_subnets
}

module "ecr" {
  source = "./modules/ecr"

  project_name = var.project_name
  environment  = var.environment
}