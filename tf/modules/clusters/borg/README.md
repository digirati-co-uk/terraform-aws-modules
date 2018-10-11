# Borg cluster

This is an ECS cluster with a particular volume configuration.

It provides:

| Name   | Description        | Default size |
|--------|--------------------|--------------|
| root   | Root volume size   | 40gb         |
| data   | General workspace  | EFS          |
| docker | Docker volume size | 40gb         |

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
| bootstrap_objects_bucket | S3 bucket where config is stored             | string |           |

## Outputs
| Parameter  | Description               | Type   |
|------------|---------------------------|--------|
| cluster_id | ID of the created cluster | string |
