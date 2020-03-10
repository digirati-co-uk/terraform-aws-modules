# /services/base/worker

Creates single ECS service only.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| cluster\_id | ECS cluster to deploy into | `any` | n/a | yes |
| desired\_count | Desired number of services | `number` | `1` | no |
| name | Service name | `any` | n/a | yes |
| project | Project tag value | `any` | n/a | yes |
| scheduling\_strategy | Use REPLICA or DAEMON scheduling strategy | `string` | `"REPLICA"` | no |
| task\_definition\_arn | ARN of the ECS Task Definition | `any` | n/a | yes |
| vpc | ID of the VPC that the cluster is deployed in | `any` | n/a | yes |

## Outputs

No output.