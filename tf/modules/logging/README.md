# Logging module

This will set up the baseline logging resources for the applications.

## Parameters
| Name                            | Description                      | Type   | Default |
|---------------------------------|----------------------------------|--------|---------|
| project                         | Project tag value                | string |         |
| cloudwatch\_log\_group_name     | CloudWatch Log Group name        | string |         |
| cloudwatch\_log\_retention_days | CloudWatch Log retention in days | string | 3       |

## Output
| Name           | Description                                            |
|----------------|--------------------------------------------------------|
| log_group_name | Name of the CloudWatch log group that has been created |

## Resources
