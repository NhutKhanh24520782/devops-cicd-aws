terraform {
  required_version = ">= 1.4.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0"
    }
  }
}

resource "aws_security_group" "bastion" {
  name        = "bastion-sg"
  description = "Security Group for Bastion Host"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH from workstation"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.workstation_ip]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] #tfsec:ignore:aws-ec2-no-public-egress-sgr
  }

  tags = {
    Name = "bastion-sg"
  }
}

resource "aws_security_group" "alb" {
  name        = "alb"
  description = "alb network traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description     = "Allow all outbound traffic"
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb-sg"
  }
}

resource "aws_security_group" "worker_node" {
  name        = "worker-node-sg"
  description = "Security Group for EKS Worker Nodes"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH from Bastion"
    from_port = 22
    to_port   = 22
    protocol = "tcp"
    security_groups = [aws_security_group.bastion.id]
  }

  ingress {
    description = "Node to Node"
    from_port = 0
    to_port   = 65535
    protocol = "-1"
    self = true
  }
  # ingress {
#   description = "Kubernetes API from Jenkins"
#   from_port   = 443
#   to_port     = 443
#   protocol    = "tcp"
#   security_groups = [
#     aws_security_group.jenkins.id
#   ]
# }
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "worker-node-sg"
  }
}

resource "aws_security_group" "endpoint" {

  name        = "endpoint-sg"
  description = "Security Group for Interface Endpoints"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTPS from Worker Nodes"
    from_port = 443
    to_port   = 443
    protocol = "tcp"
    security_groups = [aws_security_group.worker_node.id]
  }

  egress {
    description = "Allow all outbound"
    from_port = 0
    to_port   = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "endpoint-sg"
  }
}

#################################################
# Jenkins Security Group
# (Comment because Jenkins EC2 is created manually)
#################################################

# resource "aws_security_group" "jenkins" {
#   name        = "jenkins-sg"
#   description = "Security Group for Jenkins EC2"
#   vpc_id      = var.vpc_id
#   
#   # SSH from workstation

#   ingress {
#     description = "SSH from Workstation"
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = [var.workstation_ip]
#   }
#   
#   # Jenkins Web UI
#   
#   ingress {
#     description = "Jenkins UI"
#     from_port   = 8080
#     to_port     = 8080
#     protocol    = "tcp"
#     cidr_blocks = [var.workstation_ip]
#   }
#   
#   # Allow all outbound
#   
#   egress {
#     description = "Allow all outbound traffic"
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   tags = {
#     Name        = "jenkins-sg"
#     Project     = var.project_name
#     Environment = var.environment
#     Terraform   = "true"
#   }
# }