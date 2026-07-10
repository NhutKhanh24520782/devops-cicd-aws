# Terraform Infrastructure for AWS EKS Platform

This directory contains the Terraform root module and child modules for provisioning the AWS infrastructure used by the application platform. The current implementation focuses on core networking, security, identity, container registry, and Kubernetes infrastructure.

## What this Terraform project provisions

The Terraform code is responsible for provisioning the AWS-side infrastructure only. It does not provision MongoDB, which is expected to be deployed inside Kubernetes as a StatefulSet.

Provisioned resources include:
- VPC and subnets
- Internet Gateway and NAT Gateway
- Route tables and routing
- Security Groups
- IAM role for Jenkins
- Bastion host
- EKS cluster and managed node group
- ECR repositories for frontend and backend
- VPC endpoints for AWS services
- S3-based state management

## Architecture overview

```text
Internet
  ↓
Route53
  ↓
Application Load Balancer
  ↓
Amazon EKS
  ├── Frontend Pod
  ├── Backend Pod
  └── MongoDB StatefulSet (PVC + EBS)
```

Terraform is used to provision the infrastructure below the Kubernetes layer.

## Repository structure

```text
terraform/
├── main.tf                  # Root module wiring
├── provider.tf              # AWS provider configuration
├── variables.tf             # Root variables
├── outputs.tf               # Root outputs
├── versions.tf              # Terraform and provider version constraints
├── terraform.tfvars         # Environment values for dev
├── modules/
│   ├── vpc/                 # VPC, subnets, NAT, IGW
│   ├── security-group/      # SGs for ALB, bastion, nodes, endpoints
│   ├── iam/                 # Jenkins IAM role and instance profile
│   ├── endpoint/            # VPC endpoints for S3/ECR/Logs
│   ├── bastion/             # Bastion EC2 instance
│   ├── eks/                 # EKS cluster and managed node group
│   ├── ecr/                 # Frontend/backend ECR repositories
│   └── s3/                  # S3 bucket for Terraform state


## Module dependency flow

```text
VPC
  ↓
Security Group
  ↓
IAM
  ↓
Endpoint
  ↓
Bastion
  ↓
EKS
  ↓
ECR
```

## Prerequisites

Before using this Terraform project, make sure you have:
- Terraform v1.4 or newer
- AWS CLI configured with credentials
- Access to create the following AWS resources:
  - VPC, subnets, route tables, NAT gateways
  - IAM roles and instance profiles
  - EKS cluster and node groups
  - ECR repositories
  - EC2 bastion instance
  - VPC endpoints
- An AWS region configured in the variables

## Required tools

Install or confirm availability of:
- Terraform
- AWS CLI
- kubectl (for post-deployment validation)

## Configuration inputs

The root module uses variables defined in [variables.tf](variables.tf) and values provided in [terraform.tfvars](terraform.tfvars).

Key variables include:
- project_name
- environment
- region
- availability_zones
- cidr_block
- workstation_ip
- kubernetes_version
- bastion_instance_type
- bastion_ami
- key_name

## Initial setup

1. Configure AWS credentials:

```bash
aws configure
```

Or use an AWS profile:

```bash
export AWS_PROFILE=my-profile
```

2. Review and update values in [terraform.tfvars](terraform.tfvars):
- AWS region
- CIDR blocks
- subnet ranges
- workstation IP for SSH access
- project/environment names

3. Initialize Terraform:

```bash
terraform init
```

4. Validate the configuration:

```bash
terraform validate
```

5. Review the execution plan:

```bash
terraform plan -var-file=terraform.tfvars
```

6. Apply the infrastructure:

```bash
terraform apply -var-file=terraform.tfvars
```

## Remote state recommendation

The repository includes an S3 module, but the root module is not currently wired to use a remote backend. For production use, configure an S3 backend with DynamoDB state locking.

Example:

```hcl
terraform {
  backend "s3" {
    bucket         = "your-terraform-state-bucket"
    key            = "devops-project/dev/terraform.tfstate"
    region         = "ap-southeast-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
```

## Outputs

The root module exposes the following outputs:
- cluster_name
- cluster_endpoint
- vpc_id
- bastion_public_ip
- frontend_repository_url
- backend_repository_url

## Post-deployment steps

After apply completes:
1. Configure kubectl access to the EKS cluster:

```bash
aws eks update-kubeconfig --name <cluster-name> --region <region>
```

2. Deploy the application workloads (frontend, backend, MongoDB) using Kubernetes manifests or Helm.
3. Confirm the EKS node group and workloads are healthy.
4. Configure ingress, DNS, and certificates for the application.

## Notes and limitations

- Terraform provisions AWS infrastructure only.
- MongoDB is not provisioned by Terraform in this repository.
- The Jenkins EC2 instance and its Security Group are currently treated as manual or partially illustrative resources.
- The production environment entrypoint under [environments/prod](environments/prod) is still a placeholder and should be completed before using it for a real production deployment.

## Security considerations

Before using this project in a real environment, review the following:
- Restrict SSH access to the bastion host
- Review IAM policies for least privilege
- Restrict public access to the Kubernetes API endpoint where possible
- Enable encryption for all sensitive resources
- Use a remote backend and state locking
- Add monitoring, logging, and alerting for EKS and networking

## Recommended next improvements

To make this project more production-ready, consider:
- Configuring a remote S3 backend with DynamoDB locking
- Hardening IAM policies for Jenkins and EKS access
- Adding cluster autoscaling and node group scaling policies
- Adding OIDC/IRSA support for AWS service integrations
- Creating a fully wired production environment module
- Enabling additional EKS logging and security controls
