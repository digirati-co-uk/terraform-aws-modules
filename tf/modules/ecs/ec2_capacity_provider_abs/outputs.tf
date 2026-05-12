output "name" {
  value = aws_ecs_capacity_provider.capacity_provider.name
}

output "instance_role_name" {
  value = module.iam.instance_role_name
}

output "asg_arn" {
  value = aws_autoscaling_group.asg.arn
}