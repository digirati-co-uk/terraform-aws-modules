output "bastion_security_group" {
  value = aws_security_group.bastion.id
}

output "role" {
  value = aws_iam_role.bastion.name
}