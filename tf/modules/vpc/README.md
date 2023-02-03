# VPC module

Provides a single VPC with default 3 public and private subnets. Also creates s3 + dynamoDB vpc endpoints

## Parameters
| Parameter  | Description                         | Type   | Default     |
|------------|-------------------------------------|--------|-------------|
| name       | "Name" tag to apply to resources    | string |             |
| vpc_name   | Name of VPC                         | string |             |
| region     | AWS region                          | string |             |
| cidr_block | VPC CIDR block                      | string | 10.0.0.0/16 |

## Outputs
| Parameter              | Description                     | Type   |
|------------------------|---------------------------------|--------|
| vpc_id                 | ID of the created VPC           | string |
| private_subnets        | IDs of the private subnets      | list   |
| cidr_block_private     | CIDR block for private subnets  | string |
| private_route_table_id | Private subnets routetable id   | string |
| public_subnets         | IDs of the public subnets       | list   |
| cidr_block_public      | CIRD block for public subnets   | string |
| public_route_table_id  | Public subnets routetable id    | string |
