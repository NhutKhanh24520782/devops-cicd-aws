output "jenkins_role_name" {

  description = "IAM Role for Jenkins"

  value = aws_iam_role.jenkins.name

}

output "jenkins_role_arn" {

  description = "IAM Role ARN"

  value = aws_iam_role.jenkins.arn

}

output "jenkins_instance_profile" {

  description = "IAM Instance Profile"

  value = aws_iam_instance_profile.jenkins.name

}