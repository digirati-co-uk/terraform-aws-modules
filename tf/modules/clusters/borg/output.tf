output "cluster_id" {
  value = "${aws_ecs_cluster.borg.id}"
}

output "cluster_name" {
  value = "${aws_ecs_cluster.borg.name}"
}
