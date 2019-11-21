output "cluster_id" {
  value = "${aws_ecs_cluster.basic.id}"
}

output "cluster_name" {
  value = "${aws_ecs_cluster.basic.name}"
}

output "role_name" {
  value = "${aws_iam_role.basic.name}"
}
