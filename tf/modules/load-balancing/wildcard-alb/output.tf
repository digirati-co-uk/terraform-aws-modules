output "lb_arn" {
  description = "ARN of load balancer"
  value       = "${aws_alb.lb.arn}"
}

output "lb_fqdn" {
  description = "FQDN of load balancer"
  value       = "${aws_alb.lb.dns_name}"
}

output "lb_zone_id" {
  description = "Zone ID of load balancer"
  value       = "${aws_alb.lb.zone_id}"
}

output "lb_http_listener_arn" {
  description = "ARN of load balancer HTTP listener"
  value       = "${var.redirect_http_to_https ? join("", aws_alb_listener.http_redirect.*.arn) : join("", aws_alb_listener.http.*.arn)}"
}

output "lb_https_listener_arn" {
  description = "ARN of load balancer HTTPS listener"
  value       = "${aws_alb_listener.https.arn}"
}
