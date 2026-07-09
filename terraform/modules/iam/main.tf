resource "aws_iam_role_policy_attachment" "ecr" {
  role = aws_iam_role.jenkins.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}

resource "aws_iam_role_policy_attachment" "eks" {
  role = aws_iam_role.jenkins.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "cloudwatch" {
  role = aws_iam_role.jenkins.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_role_policy_attachment" "s3" {
  role = aws_iam_role.jenkins.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

# resource "aws_iam_role" "jenkins" {
#   name = "${var.project_name}-${var.environment}-jenkins-role"
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Principal = {
#           Service = "ec2.amazonaws.com"
#         }
#         Action = "sts:AssumeRole"
#       }
#     ]
#   })
#   tags = {
#   Name        = "${var.project_name}-jenkins-role"
#   Project     = var.project_name
#   Environment = var.environment
#   Terraform   = "true"
#   }
# }

# resource "aws_iam_instance_profile" "jenkins" {
#   name = "${var.project_name}-${var.environment}-jenkins-profile"
#   role = aws_iam_role.jenkins.name
# }
