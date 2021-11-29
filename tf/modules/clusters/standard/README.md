# Borg cluster

This is an ECS cluster with a mounted EFS volume, EBS volume for Docker and a mounted EBS volume containing specified folders.

It provides:

| Name     | Description        | Default size |
|----------|--------------------|--------------|
| root     | Root volume size   | 40gb         |
| data     | General workspace  | EFS          |
| data-ebs | EBS workspace      | 100gb        |
| docker   | Docker volume size | 40gb         |

## Parameters
The following parameters are available:

| Parameter                | Description                                      | Type   | Default   |
|--------------------------|--------------------------------------------------|--------|-----------|
| ami                      | AMI to use (should be ECS optimised x64)         | string |           |
| instance_type            | EC2 instance type                                | string | t2.medium |
| cluster_name             | Cluster name for AWS resources                   | string |           |
| prefix                   | Prefix for AWS resources                         | string |           |
| project                  | Project tag value                                | string |           |
| region                   | AWS region                                       | string |           |
| key_name                 | EC2 key pair name to use                         | string |           |
| subnets                  | List of VPC subnets to spread cluster across     | list   | []        |
| vpc                      | VPC to join                                      | string |           |
| swap_size_gb             | Number of GB to allocate as swap space           | string | 32        |
| min_size                 | Minimum number of instances for the cluster      | string | 1         |
| max_size                 | Maximum number of instances for the cluster      | string | 1         |
| root_size                | Size in GB for the root partition                | string | 40        |
| docker_size              | Size in GB of the Docker volume                  | string | 40        |
| data_ebs_size            | Size in GB of the EBS volume                     | string | 100       |
| mount_point_data         | Name of mount point to mount EFS volume data     | string | /data     |
| mount_point_data_ebs     | Name of mount point to mount EBS volume data     | string | /data-ebs |
| bootstrap_objects_bucket | Bucket containing objects used for bootstrapping | string |           |
| additional_config        | Any additional user-data config                  |        | ""        |
| scratch_folders          | A list of folders to create (`/scratch/*`)       | list   | []        |

## Outputs
| Parameter    | Description                 | Type   |
|--------------|-----------------------------|--------|
| cluster_id   | ARN of the created cluster  | string |
| cluster_name | Name of the created cluster | string |
