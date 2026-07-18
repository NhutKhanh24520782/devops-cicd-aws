module "vpc" {

  source = "./modules/vpc"

  project_name       = var.project_name
  cluster_name       = var.cluster_name
  environment        = var.environment
  cidr_block         = var.cidr_block
  availability_zones = var.availability_zones
  public_subnets     = var.public_subnets
  private_subnets    = var.private_subnets
  intra_subnets      = var.intra_subnets

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

  # OIDC provider created by EKS — required for EBS CSI IRSA trust policy
  oidc_provider_arn = module.eks.oidc_provider_arn
  oidc_provider     = module.eks.oidc_provider

  # IAM depends on EKS OIDC being available first
  depends_on = [module.eks]

}
module "endpoint" {
  source = "./modules/endpoint"

  project_name               = var.project_name
  environment                = var.environment
  region                     = var.region
  vpc_id                     = module.vpc.vpc_id
  intra_subnets              = module.vpc.intra_subnets
  private_route_table_ids    = module.vpc.private_route_table_ids
  endpoint_security_group_id = module.security_group.endpoint_security_group_id
}

module "bastion" {
  source = "./modules/bastion"

  project_name  = var.project_name
  environment   = var.environment
  sg_id         = module.security_group.bastion_security_group_id
  key_name      = var.key_name
  subnet_id     = module.vpc.public_subnets[0]
  ami           = var.bastion_ami
  instance_type = var.bastion_instance_type
}

module "eks" {
  source = "./modules/eks"

  project_name       = var.project_name
  environment        = var.environment
  cluster_name       = var.cluster_name
  kubernetes_version = var.kubernetes_version
  vpc_id             = module.vpc.vpc_id
  private_subnets    = module.vpc.private_subnets
}

module "ecr" {
  source = "./modules/ecr"

  project_name = var.project_name
  environment  = var.environment
}

###############################################################################
# EBS CSI Driver Addon — managed separately to break the circular dependency:
#   module.eks  → outputs oidc_provider_arn
#   module.iam  → creates ebs_csi role using oidc_provider_arn (depends_on eks)
#   aws_eks_addon → installs addon with role ARN (depends on both)
###############################################################################
resource "aws_eks_addon" "ebs_csi" {
  cluster_name             = module.eks.cluster_name
  addon_name               = "aws-ebs-csi-driver"
  service_account_role_arn = module.iam.ebs_csi_role_arn

  depends_on = [
    module.eks,
    module.iam,
  ]
}
resource "helm_release" "aws_load_balancer_controller" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"
  wait       = true

  set {
    name  = "clusterName"
    value = module.eks.cluster_name
  }

  set {
    name  = "serviceAccount.create"
    value = "true"
  }

  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.iam.lbc_role_arn
  }

  set {
    name  = "region"
    value = var.region
  }

  set {
    name  = "vpcId"
    value = module.vpc.vpc_id
  }

  depends_on = [
    module.eks,
    module.iam
  ]
}

