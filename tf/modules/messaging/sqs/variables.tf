locals {
  topic_arn = format("arn:aws:sns:%s:%s:%s", var.region, var.account_id, var.topic_name)
}

variable "queue_name" {
  description = "Name of the SQS queue to create"
}

variable "topic_name" {
  description = "Topic name for the SNS topic to subscribe the queue to"
}

variable "visibility_timeout_seconds" {
  description = "The visibility timeout for the queue"
  default     = 30
}

variable "message_retention_seconds" {
  description = "The number of seconds that SQS retains a message"
  default     = 1209600
}

variable "max_message_size" {
  description = "Maximum message size allowed by SQS, in bytes"
  default     = 262144
}

variable "delay_seconds" {
  description = "The time in seconds that the delivery of all messages in the queue will be delayed"
  default     = 0
}

variable "receive_wait_time_seconds" {
  description = "The time for which a ReceiveMessage call will wait for a message to arrive (long polling) before returning"
  default     = 0
}

variable "region" {
  description = "AWS region to create queue in"
}

variable "account_id" {
  description = "AWS account id for account to create queue in"
}

variable "max_receive_count" {
  description = "Max receive count before sending to DLQ"
  default     = 3
}

variable "raw_message_delivery" {
  description = "Whether to enable raw message delivery (the original message is directly passed, not wrapped in JSON with the original message in the message property)"
  default     = false
}