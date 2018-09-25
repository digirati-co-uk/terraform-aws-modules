output "external_zone_id" {
  value = "${data.aws_route53_zone.external.zone_id}"
}

output "internal_zone_id" {
  value = "${aws_route53_zone.internal.zone_id}"
}
