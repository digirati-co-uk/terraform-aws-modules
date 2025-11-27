# Bastion module

This is an EC2 instance that provides SSH access to private subnet(s). 

It will be provisioned with an ASG and will register itself with Route53 on startup.

## Parameters
The following parameters are available:

| Parameter                  | Description                                                   | Type   | Default       |
| -------------------------- | ------------------------------------------------------------- | ------ | ------------- |
| ami                        | AMI to use                                                    | string | latest AL2023 |
| instance_type              | EC2 instance type                                             | string | t3a.micro     |
| prefix                     | Prefix for AWS resources                                      | string |               |
| key_name                   | EC2 key pair name to use                                      | string |               |
| vpc                        | VPC to join                                                   | string |               |
| ip_whitelist               | List of CIDR blocks to allow SSH access for                   | list   | []            |
| subnets                    | VPC subnets to launch in                                      | string |               |
| dns_zone                   | DNS Hosted Zone ID to create bastion record within            | string |               |
| domain                     | Apex domain to use (e.g. dlcs.io)                             | string |               |
| hostname                   | Hostname to register bastion record with. Prepended to domain | string | bastion       |
| min_size                   | Minimum number of instances                                   | number | 1             |
| max_size                   | Maximum number of instances                                   | number | 1             |
| additional_security_groups | Additional security groups to assign                          | list   | []            |
| cron_stop                  | cron schedule for when to stop Bastion host                   | string | 0 1 1 * *"    |
| cron_start                 | cron schedule for when to start Bastion host                  | string | 30 1 1 * *"   |

> [!NOTE]
> The default cron schedule will restart the Bastion host once per month
> This will ensure it is routinely updated (e.g. to use updated AMI that has been applied)

## Outputs

| Parameter              | Description                        | Type   |
| ---------------------- | ---------------------------------- | ------ |
| bastion_security_group | ID of the bastion's security group | string |
| role                   | Name of the bastion's role         | string |
