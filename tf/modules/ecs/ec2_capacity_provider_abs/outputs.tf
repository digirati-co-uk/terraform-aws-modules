output "name" {
  value = aws_ecs_capacity_provider.capacity_provider.name
}

output "instance_role_name" {
  value = module.iam.instance_role_name
}