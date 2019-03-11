# ALB module

This module will provide an Application Load Balancer that specifically expects a wildcard certificate.

## Parameters
| Name                   | Description                                         | Type   | Default                   |
|------------------------|-----------------------------------------------------|--------|---------------------------|
| project                | Project name for tag values                         | string |                           |
| prefix                 | Prefix for AWS resources                            | string |                           |
| name                   | Suffix for load balancer appliance                  | string |                           |
| subnets                | List of subnets to associate load balancer with     | list   |                           |
| security_groups        | List of security groups to join                     | list   |                           |
| certificate_arn        | ARN of wildcard SSL certificate to use              | string |                           |
| elb_ssl_policy         | SSL policy to use on load balancer                  | string | ELBSecurityPolicy-2016-08 |
| vpc                    | ID of the VPC that the load balancer is deployed in | string |                           |
| ip_whitelist           | IP CIDR whitelist                                   | list   | 0.0.0.0/0                 |
| redirect_http_to_https | Enable default behaviour to redirect http to https  | string | false                     |

## Outputs
| Name                  | Description                         |
|-----------------------|-------------------------------------|
| lb_arn                | ARN of load balancer                |
| lb_fqdn               | FQDN of load balancer               |
| lb_zone_id            | Zone ID of load balancer            |
| lb_http_listener_arn  | ARN of load balancer HTTP listener  |
| lb_https_listener_arn | ARN of load balancer HTTPS listener |
