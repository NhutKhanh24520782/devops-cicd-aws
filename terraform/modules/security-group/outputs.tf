output "alb_security_group_id" {

  value = aws_security_group.alb.id

}

output "worker_node_security_group_id" {

  value = aws_security_group.worker_node.id

}

output "bastion_security_group_id" {

  value = aws_security_group.bastion.id

}

output "endpoint_security_group_id" {

  value = aws_security_group.endpoint.id

}