module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = var.cluster_name
  kubernetes_version = var.kubernetes_version

  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnets

  endpoint_public_access                   = true
  endpoint_private_access                  = true
  enable_cluster_creator_admin_permissions = true

  enabled_log_types = [
    "api",
    "audit",
    "authenticator"
  ]

  addons = {
    coredns    = {}
    kube-proxy = {}
    vpc-cni = {
      before_compute = true
    }

    eks-pod-identity-agent = {
      before_compute = true
    }

    # aws-ebs-csi-driver is managed as a standalone aws_eks_addon resource
    # in root main.tf to avoid circular dependency with the IAM IRSA role.
  }

  eks_managed_node_groups = {
    default = {
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["t3.small"]

      min_size     = 2
      desired_size = 2
      max_size     = 3

      disk_size     = 20
      capacity_type = "ON_DEMAND"
    }
  }

  tags = {
    Project     = var.project_name
    Environment = var.environment
    Terraform   = "true"
  }
}
