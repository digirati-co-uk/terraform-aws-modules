# Bastion module

This is a t2.micro instance that provides SSH access to a private subnet. It will be created with an Elastic IP.

## Parameters
The following parameters are available:

| Parameter     | Description                                        | Type   | Default  |
|---------------|----------------------------------------------------|--------|----------|
| ami           | AMI to use (should be ECS optimised x64)           | string |          |
| instance_type | EC2 instance type                                  | string | t2.micro |
| prefix        | Prefix for AWS resources                           | string |          |
| project       | Project tag value                                  | string |          |
| key_name      | EC2 key pair name to use                           | string |          |
| vpc           | VPC to join                                        | string |          |
| ssh_cidr_list | List of CIDR blocks to allow SSH access for        | list   | []       |
| subnet        | VPC subnet to launch in                            | string |          |
| dns_zone      | DNS Hosted Zone ID to create bastion record within | string |          |
| domain        | Apex domain to use (e.g. dlcs.io)                  | string |          |

## Outputs

| Parameter              | Description                        | Type   |
|------------------------|------------------------------------|--------|
| bastion_security_group | ID of the bastion's security group | string |
