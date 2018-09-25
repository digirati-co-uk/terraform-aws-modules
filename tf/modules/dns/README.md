# DNS module

This module will attempt to create an internal hosted zone for the given domain and parameters.

Internal hosted zone will have name based on the prefix, the region and the suffix `.internal`:

e.g. if `prefix` is `ida` and `region` is `eu-west-1`, the internal hosted zone will be `ida.eu-west-1.internal`

## Parameters

| Name    | Description                       | Type   | Default |
|---------|-----------------------------------|--------|---------|
| domain  | Apex domain to use (e.g. dlcs.io) | string |         |
| region  | AWS region                        | string |         |
| project | Project name for tag values       | string |         |
| prefix  | Prefix for AWS resources          | string |         |
| vpc     | VPC to join                       | string |         |

## Outputs

| Name              | Description                     |
|-------------------|---------------------------------|
| external\_zone_id | ID for the external Hosted Zone |
| internal\_zone_id | ID for the internal Hosted Zone |
