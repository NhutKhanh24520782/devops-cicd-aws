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

output "ebs_csi_role_arn" {
  description = "IAM Role ARN for EBS CSI Driver (passed to addon service_account_role_arn)"
  value       = aws_iam_role.ebs_csi.arn
}
