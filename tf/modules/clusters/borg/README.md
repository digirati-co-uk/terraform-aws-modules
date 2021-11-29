# Borg cluster

This is an ECS cluster with a particular volume configuration and sambda configuration.

It provides:

| Name     | Description        | Default size |
|----------|--------------------|--------------|
| root     | Root volume size   | 40gb         |
| data     | General workspace  | EFS          |
| data-ebs | EBS workspace      | 100gb        |
| docker   | Docker volume size | 40gb         |

## Parameters
The following parameters are available:

| Parameter                | Description                                  | Type   | Default   |
|--------------------------|----------------------------------------------|--------|-----------|
| ami                      | AMI to use (should be ECS optimised x64)     | string |           |
| instance_type            | EC2 instance type                            | string | t2.medium |
| cluster_name             | Cluster name for AWS resources               | string |           |
| prefix                   | Prefix for AWS resources                     | string |           |
| project                  | Project tag value                            | string |           |
| region                   | AWS region                                   | string |           |
| key_name                 | EC2 key pair name to use                     | string |           |
| subnets                  | List of VPC subnets to spread cluster across | list   | []        |
| vpc                      | VPC to join                                  | string |           |
| swap_size_gb             | Number of GB to allocate as swap space       | string | 32        |
| dockerhub_username       | DockerHub robot username                     | string |           |
| dockerhub_password       | DockerHub robot password                     | string |           |
| dockerhub_email          | DockerHub robot email                        | string |           |
| min_size                 | Minimum number of instances for the cluster  | string | 1         |
| max_size                 | Maximum number of instances for the cluster  | string | 1         |
| root_size                | Size in GB for the root partition            | string | 40        |
| docker_size              | Size in GB of the Docker volume              | string | 40        |
| data_ebs_size            | Size in GB of the EBS volume                 | string | 100       |
| bootstrap_objects_bucket | S3 bucket where config is stored             | string |           |
| mount_point_data         | Name of mount point to mount EFS volume data | string | /data     |
| mount_point_data_ebs     | Name of mount point to mount EBS volume data | string | /data-ebs |
| data_ebs_size            | Size in GB of the data EBS volume            | string | 100       |
| peered_vpc_cidr          | Optional peered VPC CIDR block               | string |           |
| peered_vpc_port_from     | Optional peered VPC port lower range         | string |           |
| peered_vpc_port_to       | Optional peered VPC port upper range         | string |           |

## Outputs
| Parameter    | Description                 | Type   |
|--------------|-----------------------------|--------|
| cluster_id   | ARN of the created cluster  | string |
| cluster_name | Name of the created cluster | string |
