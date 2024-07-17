# terraform-aws-modules

A collection of Terraform modules for AWS.

See `changelog.md` for history of changes.

## Modules

## backup

This folder contains modules related to taking automated backups.

### backup-database

Configures a scheduled ECS service which takes database backups and uploads to S3.

### backup-elasticsearch

Configures a scheduled ECS service which takes backups of ElasticSearch instance and uploads to S3 using [shutterbug](https://github.com/digirati-co-uk/shutterbug).

## bastion

An EC2 host launched by an ASG that registers itself with Route53 on startup. Provides SSH access to private subnets.

## clusters

Modules for ECS cluster EC2 host configurations.

### borg

> Avoid using this module. Prefer standard. This it creates DLCS-specific folders and contains unnecessary modifications (e.g. for ElasticSearch + Samba etc)

Create a EC2 host with EFS + EBS backed storage. Designed to be general-specialists and have modifications for ElasticSearch and Samba. Also have standard folders created.

### standard

Create a EC2 host with EFS + EBS backed storage

## data

Modules for AWS Athena / AWS Glue

### alb

Sets up AWS Glue table for ALB logs

### cloudfront

Sets up AWS Glue table for CloudFront logs

## ecs

ECS specific modules (a number of the other, older, modules are ECS specific and should be removed).

### autoscaling/scheduled

Scale in/out a service based on cron schedule

### container_definition

Helpers to construct container_definition object for use in tasks.

### ec2_capacity_provider

Create launch template, autoscaling group and capacity provider for EC2 ECS host.

### ec2_capacity_provider_abs

Similar to above but uses attribute based instance selection rather than specifying an instance type.

### task_definition

Create a task definition and relevant task + execution IAM roles

### web_ec2 + web_fargate

These modules are similar in that they both create an ECS servce, load-balancer target group, load-balancer listener rule and optionally DNS records.

The difference is on task launch_type and have been separated for simplicity and to avoid conditional logic.

## iam-baseline

Create baseline IAM config, including `FORCE_MFA` group.

## load-balancing

### target

Create ALB target group, listener rule, security groups and optional DNS records

### wildcard-alb

Create ALB with an HTTP + HTTPS listener.

## messaging

### sns

Create an SNS topic with a policy to publish to it.

### sqs

Create an SQS queue subscriped to an SNS topic with a DLQ.

## services

Modules for ECS services

> Do not use these - prefer ecs/* modules instead as they allow for better composition

### base/web

Creates ECS Service, roles, policies and accompanying ALB rules. Optionally create ssl cert and DNS entries.

### tasks

Modules related to creating and managing ECS tasks/envvars etc

#### base/sidecar/triad/quintent/quartet

Create ECS container definitions + tasks with 1,2,3,4,5 containers respectively. (_obsolete: favour `/ecs/container_definition` and `/ecs/task_definition` instead for clarity_)

#### secret_references + secrets

Helpers for setting `VALUE_FROM` properties in ECS container definitions. Calculates paths and generates permissions.

## vpc

Create a VPC with default 3 public and private subnets. Also creates s3 + dynamoDB vpc endpoints