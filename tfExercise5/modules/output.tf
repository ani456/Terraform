## outputs for module this can be used by other modules since othere modules cannot access the
## resources directly
output "jumpserver_sg_id" {
  value = aws_security_group.jumpserver-sg.id
}

output "public_subnet1_id" {
  value = aws_subnet.public-subnet1.id
}
