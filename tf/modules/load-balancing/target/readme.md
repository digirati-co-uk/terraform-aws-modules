# Target Module

This module creates the following resources:

* ALB target group
* Listener rule, changes to priority are ignored
* Security groups
* Optional Route53

## Parameters

| Name                             | Description                                                                      | Default       |
|----------------------------------|----------------------------------------------------------------------------------|---------------|
| name                             | Name of target group                                                             |               |
| vpc                              | Id of the VPC that LB is in                                                      |               |
| hostname                         | Optional hostname, prepended to `domain`, for `host_header` rule                 | ""            |
| domain                           | Hostname for LB rule                                                             |               |
| path_patterns                    | Path patterns to match in ALB                                                    | ["/*]         |
| zone_id                          | HostedZone id for creating R53 rule. Required if `create_route_53_entry` is true | ""            |
| create_route53_entry             | If true a Rotute53 alias record is created for listener                          | true          |
| ip_whitelist                     | List of CIDR blocks to allow web access for                                      | ["0.0.0.0/0"] |
| load_balancer_arn                | ARN of load balancer to add rule to                                              |               |
| listener_arn                     | ARN of listener to attach to                                                     |               |
| priority                         | Priority for listener arn                                                        |               |
| health_check_matcher             | List of HTTP status codes for health check                                       | "200,404"     |
| health_check_path                | Path to test HTTP status for health check                                        | "/"           |
| health_check_timeout             | Timeout for health check (seconds)                                               | 10            |
| health_check_healthy_threshold   | Threshold for number of healthy checks                                           | 2             |
| health_check_unhealthy_threshold | Threshold for number of unhealthy checks                                         | 2             |
| health_check_interval            | Interval between health checks (seconds)                                         | 30            |
| deregistration_delay             | Target group deregistration delay (seconds)                                      | 30            |
| target_type                      | TargetType for ELB TargetGroup                                                   | instance      |