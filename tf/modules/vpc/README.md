# VPC module

Provides a single VPC with 2 public subnets in `subnet_public_1_az` and `subnet_public_2_az`, and two private subnets in `subnet_private_1_az` and `subnet_private_2_az`.

## Parameters
| Parameter               | Description                        | Type   | Default     |
|-------------------------|------------------------------------|--------|-------------|
| region                  | AWS region                         | string |             |
| vpc_cidr                | VPC CIDR block                     | string | 10.0.0.0/16 |
| subnet\_public\_1_cidr  | Public subnet 1 CIDR block         | string | 10.0.0.0/24 |
| subnet\_public\_1_az    | Public subnet 1 Availability Zone  | string |             |
| subnet\_public\_2_cidr  | Public subnet 2 CIDR block         | string | 10.0.1.0/24 |
| subnet\_public\_2_az    | Public subnet 2 Availability Zone  | string |             |
| subnet\_private\_1_cidr | Private subnet 1 CIDR block        | string | 10.0.2.0/24 |
| subnet\_private\_1_az   | Private subnet 1 Availability Zone | string |             |
| subnet\_private\_2_cidr | Private subnet 2 CIDR block        | string | 10.0.3.0/24 |
| subnet\_private\_2_az   | Private subnet 2 Availability Zone | string |             |
| prefix                  | Prefix for AWS resources           | string |             |
| project                 | Project tag value                  | string |             |

## Outputs
| Parameter                   | Description                          | Type   |
|-----------------------------|--------------------------------------|--------|
| vpc_id                      | ID of the created VPC                | string |
| subnet\_public\_1_id        | ID of the first public subnet        | string |
| subnet\_public\_2_id        | ID of the second public subnet       | string |
| subnet\_private\_1_id       | ID of the first private subnet       | string |
| subnet\_private\_2_id       | ID of the second private subnet      | string |
| route\_table\_public\_1_id  | ID of the first public route table   | string |
| route\_table\_public\_2_id  | ID of the second public route table  | string |
| route\_table\_private\_1_id | ID of the first private route table  | string |
| route\_table\_private\_2_id | ID of the second private route table | string |
