output "secrets_string" {
  value = jsonencode(local.final_secrets)
}

output "secrets" {
  value = local.final_secrets
}
