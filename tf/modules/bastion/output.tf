output "bastion_security_group" {
  value = aws_security_group.bastion.id
}

output "role" {
  value = aws_iam_role.bastion.name
}

output "host_key_ssm_parameter" {
  description = "SSM parameter holding SSH host key"
  value       = local.host_key_param
}
