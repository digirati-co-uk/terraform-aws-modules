output "cluster_id" {
  value = aws_ecs_cluster.standard.id
}

output "cluster_name" {
  value = aws_ecs_cluster.standard.name
}

output "role_name" {
  value = aws_iam_role.standard.name
}
