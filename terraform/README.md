# Terraform Skeleton

This folder contains infrastructure-as-code modules for AWS resources.

Planned modules:
- VPC
- Public subnets
- Private subnets
- Internet Gateway
- NAT Gateway
- Security Groups
- IAM roles and policies
- ECR repository
- EKS cluster
- Jenkins EC2 instance

Environments:
- dev
- prod

Note:
The Jenkins EC2 instance and its Security Group are provisioned manually
for this project. The Terraform resources below are intentionally commented
out to demonstrate how Jenkins could be managed as Infrastructure as Code
in a production environment.