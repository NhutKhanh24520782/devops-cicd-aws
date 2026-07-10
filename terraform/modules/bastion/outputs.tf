output "public_ip" {
  description = "public ip address"
  value       = aws_instance.bastion.public_ip
}

output "instance_id" {
  value = aws_instance.bastion.id
}

output "public_dns" {
  value = aws_instance.bastion.public_dns
}