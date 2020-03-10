# /services/base/web-basic

Creates ECS Service, roles, policies and accompanying ALB rules, dependant on specified inputs.

Creates Route53 entry if `hostname` has a value.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| cluster\_id | ECS cluster to deploy into | `any` | n/a | yes |
| container\_name | Name of container | `any` | n/a | yes |
| container\_port | Port number of container | `any` | n/a | yes |
| deregistration\_delay | Target group deregistration delay (seconds) | `number` | `30` | no |
| desired\_count | Desired number of services | `number` | `1` | no |
| domain | Apex domain to use (e.g. dlcs.io) | `any` | n/a | yes |
| health\_check\_grace\_period\_seconds | Grace period for health check (seconds) | `number` | `0` | no |
| health\_check\_healthy\_threshold | Threshold for number of healthy checks | `number` | `2` | no |
| health\_check\_interval | Interval between health checks (seconds) | `number` | `30` | no |
| health\_check\_matcher | List of HTTP status codes for health check | `string` | `"200,404"` | no |
| health\_check\_path | Path to test HTTP status for health check | `string` | `"/"` | no |
| health\_check\_timeout | Timeout for health check (seconds) | `number` | `10` | no |
| health\_check\_unhealthy\_threshold | Threshold for number of unhealthy checks | `number` | `2` | no |
| hostname | (Optional) Hostname to register in Route53 | `string` | `""` | no |
| load\_balancer\_arn | ARN of ALB to attach to | `any` | n/a | yes |
| load\_balancer\_fqdn | FQDN of ALB to attach to | `any` | n/a | yes |
| load\_balancer\_http\_listener\_arn | Optional ARN of the ALB HTTP Listener to attach to | `string` | `""` | no |
| load\_balancer\_https\_listener\_arn | Optional ARN of the ALB HTTPS Listener to attach to | `string` | `""` | no |
| load\_balancer\_zone\_id | Zone ID of ALB to attach to | `any` | n/a | yes |
| name | Service name | `any` | n/a | yes |
| path\_patterns | Path patterns to match in ALB | `list` | <pre>[<br>  "/*"<br>]</pre> | no |
| project | Project tag value | `any` | n/a | yes |
| scheduling\_strategy | Use REPLICA or DAEMON scheduling strategy | `string` | `"REPLICA"` | no |
| service\_number\_http | Priority number for the service's ALB HTTP listener | `string` | `"0"` | no |
| service\_number\_https | Priority number for the service's ALB HTTPS listener | `string` | `"0"` | no |
| subnets | List of subnets to load balance | `list` | n/a | yes |
| task\_definition\_arn | ARN of the ECS Task Definition | `any` | n/a | yes |
| vpc | ID of the VPC that the cluster is deployed in | `any` | n/a | yes |
| zone\_id | ID for the Route53 Hosted Zone | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| service\_role\_name | Name of the ECS service's IAM role |
| target\_group\_arn | ARN of ALB target group |
| url | external url |