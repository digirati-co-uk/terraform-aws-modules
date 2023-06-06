# VPC module

> Prefer main vpc module - this is only included for backwards compatibility. 

Provides a single VPC with 2 public subnets in `subnet_public_1_az` and `subnet_public_2_az`, and two private subnets in `subnet_private_1_az` and `subnet_private_2_az`.

## Parameters
| Parameter             | Description                        | Type   | Default     |
|-----------------------|------------------------------------|--------|-------------|
| region                | AWS region                         | string |             |
| vpc_cidr              | VPC CIDR block                     | string | 10.0.0.0/16 |
| subnet_public_1_cidr  | Public subnet 1 CIDR block         | string | 10.0.0.0/24 |
| subnet_public_1_az    | Public subnet 1 Availability Zone  | string |             |
| subnet_public_2_cidr  | Public subnet 2 CIDR block         | string | 10.0.1.0/24 |
| subnet_public_2_az    | Public subnet 2 Availability Zone  | string |             |
| subnet_private_1_cidr | Private subnet 1 CIDR block        | string | 10.0.2.0/24 |
| subnet_private_1_az   | Private subnet 1 Availability Zone | string |             |
| subnet_private_2_cidr | Private subnet 2 CIDR block        | string | 10.0.3.0/24 |
| subnet_private_2_az   | Private subnet 2 Availability Zone | string |             |
| prefix                | Prefix for AWS resources           | string |             |
| project               | Project tag value                  | string |             |

## Outputs
| Parameter                | Description                          | Type   |
|--------------------------|--------------------------------------|--------|
| vpc_id                   | ID of the created VPC                | string |
| subnet_public_1_id       | ID of the first public subnet        | string |
| subnet_public_2_id       | ID of the second public subnet       | string |
| subnet_private_1_id      | ID of the first private subnet       | string |
| subnet_private_2_id      | ID of the second private subnet      | string |
| route_table_public_1_id  | ID of the first public route table   | string |
| route_table_public_2_id  | ID of the second public route table  | string |
| route_table_private_1_id | ID of the first private route table  | string |
| route_table_private_2_id | ID of the second private route table | string |
| nat_public_ip            | Public IP of the NAT gateway         | string |
